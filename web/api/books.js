export default function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  const books = [
    {
      book_number: 1,
      course_code: "8601",
      title: "General Methods of Teaching",
      urdu_title: "تدریس کے عمومی طریقے",
      author_dept: "Department of Early Childhood Education and Elementary Teacher Education",
      university: "Allama Iqbal Open University, Islamabad",
      total_pages: 249,
      is_scanned: false,
      units: [
        { unit: 1, title: "Teaching and Learning" },
        { unit: 2, title: "Lesson Planning" },
        { unit: 3, title: "Instructional Objectives" },
        { unit: 4, title: "Methods of Teaching" },
        { unit: 5, title: "Student-Centered Teaching Strategies" },
        { unit: 6, title: "Teacher-Centered Teaching Strategies" },
        { unit: 7, title: "Instructional Media and Technology" },
        { unit: 8, title: "Classroom Management" },
        { unit: 9, title: "Assessment of Learning" }
      ]
    },
    {
      book_number: 2,
      course_code: "8602",
      title: "Educational Assessment and Evaluation",
      urdu_title: "تعلیمی پیمائش و جائزہ",
      author_dept: "Department of Early Childhood Education and Elementary Teacher Education",
      university: "Allama Iqbal Open University, Islamabad",
      total_pages: 240,
      is_scanned: false,
      units: [
        { unit: 1, title: "Concept of Assessment and Evaluation" },
        { unit: 2, title: "Educational Objectives and Taxonomy" },
        { unit: 3, title: "Types of Assessment (Formative and Summative)" },
        { unit: 4, title: "Achievement Tests (Construction and Types)" },
        { unit: 5, title: "Objective Type Tests" },
        { unit: 6, title: "Subjective/Essay Type Tests" },
        { unit: 7, title: "Test Administration and Scoring" },
        { unit: 8, title: "Interpretation of Test Scores" },
        { unit: 9, title: "Grading and Reporting Systems" }
      ]
    },
    {
      book_number: 3,
      course_code: "8603",
      title: "Curriculum Development",
      urdu_title: "نصاب سازی اور ترقی",
      author_dept: "Department of Early Childhood Education & Elementary Teacher Education",
      university: "Allama Iqbal Open University, Islamabad",
      total_pages: 258,
      is_scanned: false,
      units: [
        { unit: 1, title: "Elements and Foundations of Curriculum" },
        { unit: 2, title: "Philosophical and Sociological Foundations" },
        { unit: 3, title: "Psychological Foundations of Curriculum" },
        { unit: 4, title: "Curriculum Planning and Process" },
        { unit: 5, title: "Curriculum Content Selection and Organization" },
        { unit: 6, title: "Curriculum Implementation" },
        { unit: 7, title: "Curriculum Evaluation and Renewal" },
        { unit: 8, title: "Curriculum Development in Pakistan" },
        { unit: 9, title: "Innovations and Trends in Curriculum" }
      ]
    },
    {
      book_number: 4,
      course_code: "8604",
      title: "Research Methods in Education",
      urdu_title: "تعلیمی تحقیق کے طریقے",
      author_dept: "Department of Early Childhood Education & Elementary Teacher Education",
      university: "Allama Iqbal Open University, Islamabad",
      total_pages: 341,
      is_scanned: false,
      units: [
        { unit: 1, title: "Introduction to Educational Research" },
        { unit: 2, title: "Identification and Formulation of Research Problem" },
        { unit: 3, title: "Types of Research (Descriptive, Experimental, Historical)" },
        { unit: 4, title: "Sampling Techniques and Procedures" },
        { unit: 5, title: "Data Collection Tools and Instruments" },
        { unit: 6, title: "Data Analysis and Statistical Interpretation" },
        { unit: 7, title: "Action Research in Education" },
        { unit: 8, title: "Writing Research Proposals and Reports" },
        { unit: 9, title: "Research Ethics and Integrity" }
      ]
    },
    {
      book_number: 5,
      course_code: "8605",
      title: "Educational Leadership and Management",
      urdu_title: "تعلیمی قیادت و انتظام",
      author_dept: "Department of Early Childhood Education & Elementary Teacher Education",
      university: "Allama Iqbal Open University, Islamabad",
      total_pages: 231,
      is_scanned: false,
      units: [
        { unit: 1, title: "Concept of Educational Management and Leadership" },
        { unit: 2, title: "Theories of Leadership and Management" },
        { unit: 3, title: "Educational Planning and Decision Making" },
        { unit: 4, title: "Educational Supervision and Inspection" },
        { unit: 5, title: "Human Resource Management in Education" },
        { unit: 6, title: "Financial Management and School Budgeting" },
        { unit: 7, title: "School Discipline and Conflict Management" },
        { unit: 8, title: "Educational Organization and Structure in Pakistan" },
        { unit: 9, title: "Total Quality Management (TQM) in Education" }
      ]
    },
    {
      book_number: 6,
      course_code: "8606",
      title: "Citizenship Education and Community Engagement",
      urdu_title: "شہریت کی تعلیم اور سماجی شمولیت",
      author_dept: "Department of Early Childhood Education & Elementary Teacher Education",
      university: "Allama Iqbal Open University, Islamabad",
      total_pages: 215,
      is_scanned: false,
      units: [
        { unit: 1, title: "Society and Culture" },
        { unit: 2, title: "Group and Group Dynamics" },
        { unit: 3, title: "Socialization and Personality Development" },
        { unit: 4, title: "Social Institutions (Family, Religion, Education)" },
        { unit: 5, title: "Social Control and Deviance" },
        { unit: 6, title: "School and Community Relationships" },
        { unit: 7, title: "The Effective Teacher in the Community" },
        { unit: 8, title: "Technological Change and Society" },
        { unit: 9, title: "Collaboration Between School and Community" }
      ]
    }
  ];

  return res.status(200).json(books);
}
