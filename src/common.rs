pub mod matrix {
    #[derive(Debug, PartialEq, Eq, Clone)]
    pub struct Location(usize, usize);

    impl From<(usize, usize)> for Location {
        fn from((row, col): (usize, usize)) -> Self {
            Location(row, col)
        }
    }

    impl From<(&usize, &usize)> for Location {
        fn from((row, col): (&usize, &usize)) -> Self {
            Location(*row, *col)
        }
    }

    impl From<(&isize, &isize)> for Location {
        fn from((row, col): (&isize, &isize)) -> Self {
            Location(*row as usize, *col as usize)
        }
    }

    #[derive(Debug)]
    pub struct Matrix<T> {
        data: Vec<Vec<T>>,
    }

    impl<T> Matrix<T> {
        pub fn get(&self, Location(row, col): &Location) -> Option<&T> {
            self.data.get(*row)?.get(*col)
        }

        pub fn set(&mut self, Location(row, col): &Location, value: T) {
            if let Some(row) = self.data.get_mut(*row) {
                row[*col] = value;
            }
        }

        pub fn location_iter(&self) -> LocationIterator<'_, T> {
            LocationIterator {
                matrix: self,
                row: 0,
                col: 0,
            }
        }

        pub fn column(&self, col: usize) -> Vec<&T> {
            self.data.iter().map(|row| &row[col]).collect()
        }

        pub fn row(&self, row: usize) -> Vec<&T> {
            self.data[row].iter().collect()
        }

        pub fn neighbors(&self, Location(row, col): &Location) -> Vec<Location> {
            let (row, col) = (*row as isize, *col as isize);
            let mut neighbors = Vec::new();

            let rows = ((row - 1)..=(row + 1))
                .filter(|&r| r >= 0 && r < self.data.len() as isize)
                .collect::<Vec<isize>>();
            let cols = ((col - 1)..=(col + 1))
                .filter(|&c| c >= 0 && c < self.data[row as usize].len() as isize)
                .collect::<Vec<isize>>();

            for r in &rows {
                for c in &cols {
                    if *r == row && *c == col {
                        continue;
                    }

                    neighbors.push((r, c).into());
                }
            }

            neighbors
        }
    }

    impl<T> From<Vec<Vec<T>>> for Matrix<T> {
        fn from(data: Vec<Vec<T>>) -> Self {
            Matrix { data }
        }
    }

    pub struct LocationIterator<'a, T> {
        matrix: &'a Matrix<T>,
        row: usize,
        col: usize,
    }

    impl<'a, T> Iterator for LocationIterator<'a, T> {
        type Item = Location;

        fn next(&mut self) -> Option<Self::Item> {
            if self.row >= self.matrix.data.len() {
                return None;
            }

            let location = Location(self.row, self.col);

            self.col += 1;
            if self.col >= self.matrix.data[self.row].len() {
                self.row += 1;
                self.col = 0;
            }

            Some(location)
        }
    }
}

pub mod graph {
    struct Node<'a, T> {
        graph: &'a AdjacencyMatrix<'a, T>,
        coord: (usize, usize),
    }

    pub trait Distance {
        fn distance(&self, other: &Self) -> f64;
    }

    pub struct AdjacencyMatrix<'a, T> {
        nodes: &'a [T],
        data: Vec<Vec<f64>>,
    }

    impl<'a, T> From<&'a [T]> for AdjacencyMatrix<'a, T>
    where
        T: Distance,
    {
        fn from(nodes: &'a [T]) -> Self {
            let mut data = vec![vec![0.0; nodes.len()]; nodes.len()];

            for i in 0..nodes.len() - 1 {
                for j in (i + 1)..nodes.len() {
                    let distance = nodes[i].distance(&nodes[j]);
                    data[i][j] = distance;
                    data[j][i] = distance;
                }
            }

            AdjacencyMatrix {
                nodes: &nodes,
                data,
            }
        }
    }
}
