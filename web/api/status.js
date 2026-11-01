export default function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  return res.status(200).json({
    status: 'online',
    indexing: {
      is_indexing: false,
      progress: '',
      error: null
    },
    database: {
      total_indexed_pages: 1534,
      total_words: 505517,
      books: [
        { book_number: 1, course_code: '8601', title: 'General Methods of Teaching', pages: 249 },
        { book_number: 2, course_code: '8602', title: 'Educational Assessment and Evaluation', pages: 240 },
        { book_number: 3, course_code: '8603', title: 'Curriculum Development', pages: 258 },
        { book_number: 4, course_code: '8604', title: 'Research Methods in Education', pages: 341 },
        { book_number: 5, course_code: '8605', title: 'Educational Leadership and Management', pages: 231 },
        { book_number: 6, course_code: '8606', title: 'Citizenship Education and Community Engagement', pages: 215 }
      ]
    }
  });
}
