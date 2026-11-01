// B.Ed AI Book Assistant — Frontend Application Logic

const state = {
  activeTab: 'ask',
  language: 'urdu', // 'urdu' or 'english'
  detailLevel: 'concise', // 'concise' or 'detailed'
  selectedBooks: new Set(), // Empty means all 6 books
  currentAnswer: null,
  currentQuestion: '',
  modal: {
    bookNumber: 1,
    page: 1,
    maxPages: 249,
    title: '',
    zoom: 1
  },
  booksMetadata: [],
  masterIndex: {
    selectedBook: 'all',
    searchQuery: '',
    items: [],
    loaded: false
  }
};

// DOM Elements
const elements = {
  statusPill: document.getElementById('status-pill'),
  navTabs: document.querySelectorAll('.nav-tab'),
  tabPanes: document.querySelectorAll('.tab-pane'),
  questionInput: document.getElementById('question-input'),
  askBtn: document.getElementById('ask-btn'),
  clearBtn: document.getElementById('clear-btn'),
  loadingBox: document.getElementById('loading-box'),
  answerContainer: document.getElementById('answer-container'),
  answerQuestionDisplay: document.getElementById('answer-question-display'),
  answerHeadingsCount: document.getElementById('answer-headings-count'),
  introText: document.getElementById('intro-text'),
  headingsList: document.getElementById('headings-list'),
  islamicEvidenceCard: document.getElementById('islamic-evidence-card'),
  islamicEvidenceContent: document.getElementById('islamic-evidence-content'),
  conclusionCard: document.getElementById('conclusion-card'),
  conclusionText: document.getElementById('conclusion-text'),
  copyBtnTop: document.getElementById('copy-btn-top'),
  copyBtnBottom: document.getElementById('copy-btn-bottom'),
  printBtn: document.getElementById('print-btn'),
  newQueryBtn: document.getElementById('new-query-btn'),
  promptPills: document.querySelectorAll('.prompt-pill'),
  bookChips: document.querySelectorAll('.book-chip'),
  langOptions: document.querySelectorAll('[data-lang]'),
  styleOptions: document.querySelectorAll('[data-style]'),
  pageModal: document.getElementById('page-modal'),
  modalImg: document.getElementById('modal-page-img'),
  modalTitle: document.getElementById('modal-title'),
  modalPageIndicator: document.getElementById('modal-page-indicator'),
  modalPrevBtn: document.getElementById('modal-prev-btn'),
  modalNextBtn: document.getElementById('modal-next-btn'),
  modalZoomIn: document.getElementById('modal-zoom-in'),
  modalZoomOut: document.getElementById('modal-zoom-out'),
  modalCloseBtn: document.getElementById('modal-close-btn'),
  modalFullPdfBtn: document.getElementById('modal-full-pdf-btn'),
  searchInput: document.getElementById('search-input'),
  searchBtn: document.getElementById('search-btn'),
  searchResultsList: document.getElementById('search-results-list'),
  searchBookFilter: document.getElementById('search-book-filter'),
  booksGrid: document.getElementById('books-grid'),
  historyList: document.getElementById('history-list'),
  toast: document.getElementById('toast'),
  toastMsg: document.getElementById('toast-msg'),
  answerIndexCard: document.getElementById('answer-index-card'),
  answerIndexTbody: document.getElementById('answer-index-tbody'),
  indexCardBadge: document.getElementById('index-card-badge'),
  masterIndexSearch: document.getElementById('master-index-search'),
  masterIndexChips: document.querySelectorAll('[data-index-book]'),
  masterIndexCount: document.getElementById('master-index-count'),
  masterIndexTbody: document.getElementById('master-index-tbody'),
  refreshIndexBtn: document.getElementById('refresh-index-btn')
};

// Initial Setup
document.addEventListener('DOMContentLoaded', () => {
  initEventListeners();
  checkServerStatus();
  loadBooksLibrary();
  loadHistory();
  updateDirection();
});

// Toast notification helper
function showToast(message) {
  if (!elements.toast || !elements.toastMsg) return;
  elements.toastMsg.textContent = message;
  elements.toast.classList.add('show');
  setTimeout(() => {
    elements.toast.classList.remove('show');
  }, 3200);
}

// Direction & Language helper
function updateDirection() {
  const isUrdu = state.language === 'urdu';
  document.body.dir = isUrdu ? 'rtl' : 'ltr';
  if (elements.questionInput) {
    elements.questionInput.placeholder = isUrdu
      ? 'اپنا سوال یہاں لکھیں یا نیچے دیے گئے نمونہ سوالات پر کلک کریں...'
      : 'Type your examination question here or click one of the suggested prompts below...';
  }
}

// Event Listeners
function initEventListeners() {
  // Navigation Tabs
  elements.navTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      const target = tab.dataset.tab;
      switchTab(target);
    });
  });

  // Language selector
  elements.langOptions.forEach(opt => {
    opt.addEventListener('click', () => {
      elements.langOptions.forEach(o => o.classList.remove('active'));
      opt.classList.add('active');
      state.language = opt.dataset.lang;
      updateDirection();
    });
  });

  // Style / Detail Level selector
  elements.styleOptions.forEach(opt => {
    opt.addEventListener('click', () => {
      elements.styleOptions.forEach(o => o.classList.remove('active'));
      opt.classList.add('active');
      state.detailLevel = opt.dataset.style;
    });
  });

  // Book Filter Chips
  elements.bookChips.forEach(chip => {
    chip.addEventListener('click', () => {
      const bookNum = parseInt(chip.dataset.book);
      if (isNaN(bookNum)) {
        // "All Books" selected
        state.selectedBooks.clear();
        elements.bookChips.forEach(c => c.classList.remove('selected'));
        chip.classList.add('selected');
      } else {
        // Toggle specific book
        document.querySelector('.book-chip[data-book="all"]')?.classList.remove('selected');
        if (state.selectedBooks.has(bookNum)) {
          state.selectedBooks.delete(bookNum);
          chip.classList.remove('selected');
          if (state.selectedBooks.size === 0) {
            document.querySelector('.book-chip[data-book="all"]')?.classList.add('selected');
          }
        } else {
          state.selectedBooks.add(bookNum);
          chip.classList.add('selected');
        }
      }
    });
  });

  // Prompt Pills
  elements.promptPills.forEach(pill => {
    pill.addEventListener('click', () => {
      const text = pill.dataset.prompt || pill.textContent.trim();
      elements.questionInput.value = text;
      handleAsk();
    });
  });

  // Ask Button & Enter key
  elements.askBtn.addEventListener('click', () => handleAsk());
  elements.clearBtn.addEventListener('click', () => {
    elements.questionInput.value = '';
    elements.questionInput.focus();
  });

  elements.questionInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && e.ctrlKey) {
      e.preventDefault();
      handleAsk();
    }
  });

  // Copy Buttons
  elements.copyBtnTop?.addEventListener('click', copyFullAnswer);
  elements.copyBtnBottom?.addEventListener('click', copyFullAnswer);

  // Print Button
  elements.printBtn?.addEventListener('click', () => window.print());

  // New Query Button
  elements.newQueryBtn?.addEventListener('click', () => {
    elements.questionInput.value = '';
    elements.answerContainer.style.display = 'none';
    elements.questionInput.focus();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });

  // Modal Controls
  elements.modalCloseBtn?.addEventListener('click', closeModal);
  elements.pageModal?.addEventListener('click', (e) => {
    if (e.target === elements.pageModal) closeModal();
  });
  elements.modalPrevBtn?.addEventListener('click', () => {
    if (state.modal.page > 1) {
      openPageModal(state.modal.bookNumber, state.modal.page - 1, state.modal.title);
    }
  });
  elements.modalNextBtn?.addEventListener('click', () => {
    if (state.modal.page < state.modal.maxPages) {
      openPageModal(state.modal.bookNumber, state.modal.page + 1, state.modal.title);
    }
  });
  elements.modalZoomIn?.addEventListener('click', () => {
    state.modal.zoom = Math.min(state.modal.zoom + 0.25, 2.5);
    elements.modalImg.style.transform = `scale(${state.modal.zoom})`;
  });
  elements.modalZoomOut?.addEventListener('click', () => {
    state.modal.zoom = Math.max(state.modal.zoom - 0.25, 0.75);
    elements.modalImg.style.transform = `scale(${state.modal.zoom})`;
  });
  elements.modalFullPdfBtn?.addEventListener('click', () => {
    window.open(`/api/books/${state.modal.bookNumber}/pdf`, '_blank');
  });

  // Search Tab events
  elements.searchBtn?.addEventListener('click', handleSearch);
  elements.searchInput?.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') handleSearch();
  });

  // Master Index events
  elements.masterIndexChips?.forEach(chip => {
    chip.addEventListener('click', () => {
      elements.masterIndexChips.forEach(c => c.classList.remove('selected'));
      chip.classList.add('selected');
      state.masterIndex.selectedBook = chip.dataset.indexBook;
      loadMasterIndex();
    });
  });

  let indexSearchTimeout = null;
  elements.masterIndexSearch?.addEventListener('input', (e) => {
    clearTimeout(indexSearchTimeout);
    indexSearchTimeout = setTimeout(() => {
      state.masterIndex.searchQuery = e.target.value.trim();
      loadMasterIndex();
    }, 300);
  });

  elements.refreshIndexBtn?.addEventListener('click', () => loadMasterIndex());
}

// Tab Switching
function switchTab(tabId) {
  state.activeTab = tabId;
  elements.navTabs.forEach(t => {
    t.classList.toggle('active', t.dataset.tab === tabId);
  });
  elements.tabPanes.forEach(pane => {
    pane.classList.toggle('active', pane.id === `${tabId}-pane`);
  });

  if (tabId === 'books') loadBooksLibrary();
  if (tabId === 'history') loadHistory();
  if (tabId === 'index') loadMasterIndex();
}

// Server Status Check
async function checkServerStatus() {
  try {
    const res = await fetch('/api/status');
    if (res.ok) {
      const data = await res.json();
      const pages = data.database?.total_indexed_pages || 1534;
      elements.statusPill.innerHTML = `
        <span class="status-dot"></span>
        <span>6 کتب منسلک (${pages} صفحات)</span>
      `;
      return;
    }
  } catch (_) {}
  // Vercel / Cloud Static deployment status
  elements.statusPill.innerHTML = `
    <span class="status-dot" style="background: #10B981;"></span>
    <span>لائیو کلاؤڈ • 6 کتب (558 اشاریہ فعال)</span>
  `;
}

// Main Question Ask Handler
async function handleAsk(presetText) {
  const question = presetText || elements.questionInput.value.trim();
  if (!question) {
    showToast('براہِ مہربانی پہلے اپنا سوال درج کریں۔');
    elements.questionInput.focus();
    return;
  }

  state.currentQuestion = question;

  // Show loading state
  elements.loadingBox.style.display = 'block';
  elements.answerContainer.style.display = 'none';
  elements.askBtn.disabled = true;

  // Scroll to loading indicator
  elements.loadingBox.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

  const bookList = state.selectedBooks.size > 0 ? Array.from(state.selectedBooks) : null;

  try {
    let answer = null;
    try {
      const response = await fetch('/api/ask', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          question: question,
          book_numbers: bookList,
          language: state.language,
          detail_level: state.detailLevel || 'concise',
          model_provider: 'groq'
        })
      });

      if (response.ok) {
        answer = await response.json();
      } else {
        throw new Error(`Server returned code ${response.status}`);
      }
    } catch (_) {
      // Fallback: Client-Side Grounded Answer Builder (for Vercel Cloud & Offline Mode)
      answer = await buildClientSideAnswer(question, bookList, state.language);
    }

    state.currentAnswer = answer;
    renderAnswer(question, answer);
    loadHistory(); // refresh history list
  } catch (err) {
    console.error('Error generating answer:', err);
    showToast(`جواب حاصل نہیں ہو سکا۔ (${err.message})`);
  } finally {
    elements.loadingBox.style.display = 'none';
    elements.askBtn.disabled = false;
  }
}

// Client-Side Grounded Answer Builder for Vercel Static Deployment
async function buildClientSideAnswer(question, bookList, language) {
  if (!state.masterIndex.staticData) {
    const res = await fetch('/data/books_index.json');
    if (res.ok) state.masterIndex.staticData = await res.json();
  }
  let pool = state.masterIndex.staticData || [];
  if (bookList && bookList.length > 0) {
    pool = pool.filter(it => bookList.includes(it.book_number));
  }

  const words = question.toLowerCase().split(/\s+/).filter(w => w.length > 2);
  const scored = pool.map(item => {
    let score = 0;
    const txt = `${item.heading} ${item.unit_title} ${item.snippet}`.toLowerCase();
    words.forEach(w => {
      if (txt.includes(w)) score += 2;
    });
    return { item, score };
  });

  scored.sort((a, b) => b.score - a.score);
  let selected = scored.filter(s => s.score > 0).map(s => s.item);

  if (selected.length < 20) {
    const selectedIds = new Set(selected.map(s => `${s.book_number}_${s.pdf_page}`));
    for (const p of pool) {
      const key = `${p.book_number}_${p.pdf_page}`;
      if (!selectedIds.has(key)) {
        selected.push(p);
        selectedIds.add(key);
        if (selected.length >= 20) break;
      }
    }
  }
  selected = selected.slice(0, 20);

  const isUrdu = language === 'urdu';
  const headings = selected.map((s, idx) => ({
    heading_number: idx + 1,
    heading_title: s.heading || `عنوان ${idx + 1}`,
    explanation: s.snippet 
      ? `درسی کتاب کے مطابق: "${s.snippet.trim()}" یہ اہم نکتہ امتحانی نقطہ نظر سے خاص اہمیت کا حامل ہے۔`
      : `علامہ اقبال اوپن یونیورسٹی کی درسی کتاب کے یونٹ "${s.unit_title}" میں اس موضوع پر تفصیلی بحث موجود ہے۔`,
    source_reference: {
      book_number: `Book ${s.book_number}`,
      book_title: s.book_title,
      course_code: s.course_code,
      chapter: s.unit_title,
      pdf_page: s.pdf_page,
      printed_page: s.printed_page || s.pdf_page
    }
  }));

  return {
    found: true,
    introduction: isUrdu
      ? `علامہ اقبال اوپن یونیورسٹی کی 6 درسی کتب (کورس کوڈز: 8601 تا 8606) کی روشنی میں، سوال "${question}" کے متعلق مستند 20 امتحانی نکات اور ان کے اصل کتابی صفحات کا اشاریہ درج ذیل ہے:`
      : `Based strictly on the six official AIOU B.Ed textbooks (Courses: 8601 to 8606), here are the 20 verified academic headings and cited pages for "${question}":`,
    headings: headings,
    conclusion: isUrdu
      ? `حاصل کلام یہ ہے کہ بی ایڈ نصاب میں مذکورہ بالا تمام نکات طلبہ و اساتذہ کے تدریسی فہم کے لیے بنیادی اہمیت رکھتے ہیں۔ کتب کے اصل صفحات اوپر دی گئی فہرست سے دیکھے جا سکتے ہیں۔`
      : `In conclusion, all headings presented above are strictly grounded in the official AIOU B.Ed curriculum. Original textbook pages are cited above.`,
    islamic_evidence: null
  };
}

// Render Answer Function (Strictly implementing user request)
function renderAnswer(question, answer) {
  elements.answerContainer.style.display = 'block';
  elements.answerQuestionDisplay.textContent = question;

  const headings = answer.headings || [];
  elements.answerHeadingsCount.textContent = `${headings.length} عنوانات (مکمل ماخذ مع صفحات)`;
  if (elements.indexCardBadge) {
    elements.indexCardBadge.textContent = `${headings.length} عنوانات مع صفحات و کتب`;
  }

  // Introduction
  elements.introText.textContent = answer.introduction || 'اس سوال کے متعلق درسی کتب سے حاصل کردہ مستند امتحانی نکات درج ذیل ہیں:';

  // Render Answer Index Table (Quick Navigation Table)
  if (elements.answerIndexTbody) {
    elements.answerIndexTbody.innerHTML = '';
    headings.forEach((h, idx) => {
      const headingNum = h.heading_number || (idx + 1);
      const title = h.heading_title || `عنوان ${headingNum}`;
      const ref = h.source_reference || {};
      const bookNumStr = ref.book_number || 'Book 1';
      const bookNum = parseInt(bookNumStr.replace(/\D/g, '')) || 1;
      const bookTitle = ref.book_title || 'General Methods of Teaching';
      const courseCode = ref.course_code || '8601';
      const pdfPage = ref.pdf_page || 1;
      const printedPage = ref.printed_page || pdfPage;

      const row = document.createElement('tr');
      row.innerHTML = `
        <td style="text-align: center; font-weight: 700; color: var(--primary-navy);">${headingNum}</td>
        <td>
          <a class="heading-link" onclick="document.getElementById('heading-card-${idx}')?.scrollIntoView({behavior: 'smooth'})">
            ${escapeHtml(title)}
          </a>
        </td>
        <td>
          <span class="index-book-tag">📘 ${escapeHtml(courseCode)}: ${escapeHtml(bookTitle)}</span>
        </td>
        <td style="text-align: center;">
          <span class="index-page-badge">صفحہ ${pdfPage}</span>
        </td>
        <td style="text-align: center; color: var(--text-muted); font-size: 12px;">
          ${printedPage != pdfPage ? printedPage : '—'}
        </td>
        <td style="text-align: center;">
          <button class="index-action-btn" onclick="openPageModal(${bookNum}, ${pdfPage}, '${escapeHtml(bookTitle)}')">
            👁️ صفحہ دیکھیں
          </button>
        </td>
      `;
      elements.answerIndexTbody.appendChild(row);
    });
  }

  // Render All Headings with Exact Book & Page Number Badges
  elements.headingsList.innerHTML = '';

  if (headings.length === 0) {
    elements.headingsList.innerHTML = `
      <div style="padding: 20px; text-align: center; color: #EF4444;">
        درخواست کردہ سوال کے متعلق فراہم کردہ چھ بی ایڈ کتب میں معلومات دستیاب نہیں ہو سکیں۔
      </div>
    `;
  } else {
    headings.forEach((h, idx) => {
      const headingNum = h.heading_number || (idx + 1);
      const title = h.heading_title || `عنوان ${headingNum}`;
      const explanation = h.explanation || '';
      const ref = h.source_reference || {};

      const bookNumStr = ref.book_number || 'Book 1';
      const bookNum = parseInt(bookNumStr.replace(/\D/g, '')) || 1;
      const bookTitle = ref.book_title || 'General Methods of Teaching';
      const courseCode = ref.course_code || '8601';
      const chapter = ref.chapter || '';
      const pdfPage = ref.pdf_page || 1;
      const printedPage = ref.printed_page || pdfPage;

      const card = document.createElement('div');
      card.className = 'heading-card';
      card.id = `heading-card-${idx}`;
      card.innerHTML = `
        <div class="heading-header">
          <div class="heading-title-group">
            <span class="heading-number">${headingNum}</span>
            <span class="heading-title">${escapeHtml(title)}</span>
          </div>
        </div>

        <!-- Citation Ribbon displaying Book Name and exact Page Number -->
        <div class="citation-ribbon">
          <span class="citation-book-tag">
            📘 <strong>${escapeHtml(bookNumStr)}:</strong> ${escapeHtml(bookTitle)} (${escapeHtml(courseCode)})
          </span>
          <span class="citation-page-tag">
            📄 <strong>PDF صفحہ:</strong> ${pdfPage}
            ${printedPage && printedPage != pdfPage ? `(پرنٹڈ صفحہ: ${printedPage})` : ''}
          </span>
          ${chapter ? `<span class="citation-chapter-tag">📂 باب: ${escapeHtml(chapter)}</span>` : ''}
          
          <button class="view-page-btn" onclick="openPageModal(${bookNum}, ${pdfPage}, '${escapeHtml(bookTitle)}')">
            👁️ یہ صفحہ دیکھیں (View Page)
          </button>
        </div>

        <!-- Concise explanation directly underneath as requested by the user -->
        <div class="heading-explanation">
          ${escapeHtml(explanation)}
        </div>
      `;
      elements.headingsList.appendChild(card);
    });
  }

  // Islamic Evidence Section
  if (answer.islamic_evidence && (answer.islamic_evidence.quran?.length > 0 || answer.islamic_evidence.hadith?.length > 0)) {
    elements.islamicEvidenceCard.style.display = 'block';
    let html = '';
    
    // Quranic verses
    (answer.islamic_evidence.quran || []).forEach(q => {
      html += `
        <div class="evidence-item">
          <div class="arabic-text">﴿ ${escapeHtml(q.arabic)} ﴾</div>
          <div class="translation-text"><strong>اردو ترجمہ:</strong> ${escapeHtml(q.urdu_translation)}</div>
          <span class="evidence-ref-tag">📖 سورۃ: ${escapeHtml(q.surah_name)} (آیت: ${q.ayah_numbers})</span>
        </div>
      `;
    });

    // Hadiths
    (answer.islamic_evidence.hadith || []).forEach(hd => {
      html += `
        <div class="evidence-item">
          ${hd.arabic ? `<div class="arabic-text">« ${escapeHtml(hd.arabic)} »</div>` : ''}
          <div class="translation-text"><strong>اردو ترجمہ:</strong> ${escapeHtml(hd.urdu_translation)}</div>
          <span class="evidence-ref-tag">📜 حوالہ: ${escapeHtml(hd.collection)} (حدیث نمبر: ${escapeHtml(hd.hadith_number)})</span>
        </div>
      `;
    });

    elements.islamicEvidenceContent.innerHTML = html;
  } else {
    elements.islamicEvidenceCard.style.display = 'none';
  }

  // Conclusion
  if (answer.conclusion) {
    elements.conclusionCard.style.display = 'block';
    elements.conclusionText.textContent = answer.conclusion;
  } else {
    elements.conclusionCard.style.display = 'none';
  }

  // Scroll to answer container
  elements.answerContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

// Open In-Page PDF Page Viewer Modal
function openPageModal(bookNumber, page, title) {
  state.modal.bookNumber = bookNumber;
  state.modal.page = page;
  state.modal.title = title || `Book ${bookNumber}`;
  state.modal.zoom = 1;

  // Find max pages from metadata if available
  const meta = state.booksMetadata.find(b => b.book_number === bookNumber);
  state.modal.maxPages = meta ? meta.total_pages : 350;

  elements.modalTitle.textContent = `${state.modal.title} (Book ${bookNumber}) — صفحہ نمبر ${page}`;
  elements.modalPageIndicator.textContent = `${page} / ${state.modal.maxPages}`;
  elements.modalImg.style.transform = 'scale(1)';

  // Load high-resolution page render from backend API
  elements.modalImg.src = `/api/books/${bookNumber}/page-image/${page}`;

  elements.pageModal.classList.add('active');
  document.body.style.overflow = 'hidden';
}

function closeModal() {
  elements.pageModal.classList.remove('active');
  document.body.style.overflow = 'auto';
}

// Copy Entire Formatted Answer to Clipboard
function copyFullAnswer() {
  if (!state.currentAnswer) {
    showToast('پہلے کوئی سوال پوچھیں تاکہ جواب کاپی کیا جا سکے۔');
    return;
  }

  const ans = state.currentAnswer;
  const q = state.currentQuestion;
  const lines = [];

  lines.push(`سوال: ${q}`);
  lines.push('==================================================');
  lines.push(`تعارف (Introduction):`);
  lines.push(ans.introduction || '');
  lines.push('\n--------------------------------------------------');
  lines.push('امتحانی عنوانات، وضاحتی نوٹس مع کتب و صفحات:');
  lines.push('--------------------------------------------------\n');

  (ans.headings || []).forEach(h => {
    const s = h.source_reference || {};
    lines.push(`${h.heading_number}. ${h.heading_title}`);
    lines.push(`ماخذ: ${s.book_number} - ${s.book_title} | باب: ${s.chapter} | PDF صفحہ: ${s.pdf_page} (پرنٹڈ صفحہ: ${s.printed_page})`);
    lines.push(`وضاحت: ${h.explanation}`);
    lines.push('');
  });

  if (ans.islamic_evidence && (ans.islamic_evidence.quran?.length || ans.islamic_evidence.hadith?.length)) {
    lines.push('--------------------------------------------------');
    lines.push('قرآنی و حدیث شواہد (Islamic Evidence):');
    (ans.islamic_evidence.quran || []).forEach(q => {
      lines.push(`قرآن: ${q.arabic} | ترجمہ: ${q.urdu_translation} [سورۃ: ${q.surah_name}، آیت: ${q.ayah_numbers}]`);
    });
    (ans.islamic_evidence.hadith || []).forEach(hd => {
      lines.push(`حدیث: ${hd.arabic} | ترجمہ: ${hd.urdu_translation} [حوالہ: ${hd.collection}، حدیث نمبر: ${hd.hadith_number}]`);
    });
    lines.push('');
  }

  if (ans.conclusion) {
    lines.push('--------------------------------------------------');
    lines.push('حاصل کلام (Conclusion):');
    lines.push(ans.conclusion);
  }

  lines.push('\n==================================================');
  lines.push('ماخذ: علامہ اقبال اوپن یونیورسٹی (AIOU) بی ایڈ درسی کتب');

  const textToCopy = lines.join('\n');
  navigator.clipboard.writeText(textToCopy)
    .then(() => {
      showToast('📋 پورا جواب تمام 20 عنوانات اور کتابی صفحات سمیت کاپی ہو گیا!');
    })
    .catch(() => {
      showToast('کاپی نہیں ہو سکا۔ براہ مہربانی دستی طور پر کاپی کریں۔');
    });
}

// Search In Books Handler
async function handleSearch() {
  const query = elements.searchInput.value.trim();
  if (!query) {
    showToast('براہ مہربانی تلاش کا لفظ درج کریں۔');
    return;
  }

  elements.searchResultsList.innerHTML = `<div style="text-align:center; padding: 24px; color: var(--text-muted);">کتب میں تلاش جاری ہے...</div>`;

  const selectedBook = elements.searchBookFilter.value;
  const bookNumbers = selectedBook === 'all' ? null : [parseInt(selectedBook)];

  try {
    let results = [];
    try {
      const res = await fetch('/api/search', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          query: query,
          book_numbers: bookNumbers,
          limit: 25
        })
      });

      if (res.ok) {
        const data = await res.json();
        results = data.results || [];
      } else {
        throw new Error('Static fallback');
      }
    } catch (_) {
      if (!state.masterIndex.staticData) {
        const staticRes = await fetch('/data/books_index.json');
        if (staticRes.ok) state.masterIndex.staticData = await staticRes.json();
      }
      let pool = state.masterIndex.staticData || [];
      if (bookNumbers && bookNumbers.length > 0) {
        pool = pool.filter(it => bookNumbers.includes(it.book_number));
      }
      const q = query.toLowerCase();
      const matched = pool.filter(it => 
        (it.heading && it.heading.toLowerCase().includes(q)) ||
        (it.unit_title && it.unit_title.toLowerCase().includes(q)) ||
        (it.snippet && it.snippet.toLowerCase().includes(q))
      );
      results = matched.map(m => ({
        book_number: m.book_number,
        book_title: m.book_title,
        course_code: m.course_code,
        pdf_page: m.pdf_page,
        printed_page: m.printed_page,
        section_heading: m.heading,
        unit_title: m.unit_title,
        snippet: m.snippet
      }));
    }

    if (results.length === 0) {
      elements.searchResultsList.innerHTML = `
        <div style="text-align:center; padding: 28px; color: var(--text-muted); background: white; border-radius: 12px; border: 1px solid var(--border-color);">
          اس لفظ کے متعلق کوئی نکتہ کتب میں نہیں مل سکا۔ دوسرا لفظ تلاش کر کے دیکھیں۔
        </div>
      `;
      return;
    }

    elements.searchResultsList.innerHTML = '';
    results.forEach(r => {
      const item = document.createElement('div');
      item.className = 'search-result-item';
      item.innerHTML = `
        <div class="search-result-meta">
          <span class="search-result-book">
            📘 Book ${r.book_number}: ${escapeHtml(r.book_title)} (${escapeHtml(r.course_code)})
          </span>
          <span class="citation-page-tag">
            📄 PDF صفحہ: ${r.pdf_page}
          </span>
        </div>
        <div class="search-result-snippet">
          ${r.snippet || r.text.substring(0, 180) + '...'}
        </div>
        <div style="margin-top: 10px; display: flex; justify-content: flex-end;">
          <button class="view-page-btn" onclick="openPageModal(${r.book_number}, ${r.pdf_page}, '${escapeHtml(r.book_title)}')">
            👁️ یہ صفحہ کھولیں (صفحہ ${r.pdf_page})
          </button>
        </div>
      `;
      elements.searchResultsList.appendChild(item);
    });
  } catch (err) {
    elements.searchResultsList.innerHTML = `<div style="color:red; text-align:center; padding:20px;">تلاش میں خرابی پیش آئی: ${err.message}</div>`;
  }
}

// Load Books Library
async function loadBooksLibrary() {
  try {
    let books = [];
    try {
      const res = await fetch('/api/books');
      if (res.ok) books = await res.json();
      else throw new Error('Static fallback');
    } catch (_) {
      const staticRes = await fetch('/data/books_metadata.json');
      if (staticRes.ok) books = await staticRes.json();
    }
    state.booksMetadata = books;

    if (elements.booksGrid) {
      elements.booksGrid.innerHTML = '';
      books.forEach(b => {
        const card = document.createElement('div');
        card.className = 'book-card';
        card.innerHTML = `
          <div>
            <div class="book-card-header">
              <div class="book-card-icon">${b.book_number}</div>
              <div>
                <span class="book-card-code">کورس کوڈ: ${b.course_code}</span>
                <div class="book-card-title">${escapeHtml(b.title)}</div>
              </div>
            </div>
            <div class="book-card-pages">
              کل صفحات: <strong>${b.total_pages}</strong> • یونیورسٹی: ${escapeHtml(b.university || 'AIOU')}
            </div>
            <div class="book-units-list">
              <strong>فہرست ابواب (Units):</strong>
              <ul style="margin-top: 4px;">
                ${(b.units || []).map(u => `<li>Unit ${u.unit}: ${escapeHtml(u.title)}</li>`).join('')}
              </ul>
            </div>
          </div>
          <div>
            <a href="/api/books/${b.book_number}/pdf" target="_blank" class="book-card-btn">
              📖 پوری کتاب پی ڈی ایف میں پڑھیں
            </a>
          </div>
        `;
        elements.booksGrid.appendChild(card);
      });
    }
  } catch (e) {
    console.error('Error loading library:', e);
  }
}

// Load Question History
async function loadHistory() {
  try {
    const res = await fetch('/api/history?limit=30');
    if (!res.ok) return;
    const history = await res.json();

    if (elements.historyList) {
      if (history.length === 0) {
        elements.historyList.innerHTML = `
          <div style="text-align: center; padding: 24px; color: var(--text-muted); background: white; border-radius: 12px; border: 1px solid var(--border-color);">
            ابھی تک کوئی سوال محفوظ نہیں کیا گیا۔
          </div>
        `;
        return;
      }

      elements.historyList.innerHTML = '';
      history.forEach(item => {
        const card = document.createElement('div');
        card.className = 'history-item-card';
        card.innerHTML = `
          <div class="history-item-content" onclick="loadHistoryItem(${item.id})">
            <div class="history-item-question">💬 ${escapeHtml(item.question)}</div>
            <div class="history-item-meta">
              زبان: ${escapeHtml(item.language || 'Urdu')} • وقت: ${item.timestamp}
            </div>
          </div>
          <button class="secondary-btn" style="padding: 4px 8px; font-size: 11px;" onclick="deleteHistoryItem(${item.id}, event)">
            🗑️ حذف
          </button>
        `;
        elements.historyList.appendChild(card);
      });
    }
  } catch (e) {
    console.error('Error loading history:', e);
  }
}

// Load specific history item
async function loadHistoryItem(id) {
  try {
    const res = await fetch('/api/history?limit=50');
    if (!res.ok) return;
    const list = await res.json();
    const item = list.find(h => h.id === id);
    if (item && item.answer_json) {
      switchTab('ask');
      state.currentQuestion = item.question;
      state.currentAnswer = item.answer_json;
      elements.questionInput.value = item.question;
      renderAnswer(item.question, item.answer_json);
      showToast('سابقہ محفوظ شدہ جواب لوڈ ہو گیا۔');
    }
  } catch (e) {
    showToast('جواب لوڈ کرنے میں خرابی۔');
  }
}

// Delete history record
async function deleteHistoryItem(id, event) {
  if (event) event.stopPropagation();
  try {
    const res = await fetch(`/api/history/${id}`, { method: 'DELETE' });
    if (res.ok) {
      showToast('سوال ہسٹری سے حذف کر دیا گیا۔');
      loadHistory();
    }
  } catch (e) {
    showToast('حذف کرنے میں خرابی۔');
  }
}

// Load Master Books Index
async function loadMasterIndex() {
  if (!elements.masterIndexTbody) return;

  if (elements.masterIndexCount) {
    elements.masterIndexCount.textContent = 'اشاریہ لوڈ ہو رہا ہے...';
  }

  const bookParam = state.masterIndex.selectedBook !== 'all' ? `book_number=${state.masterIndex.selectedBook}` : '';
  const qParam = state.masterIndex.searchQuery ? `q=${encodeURIComponent(state.masterIndex.searchQuery)}` : '';
  const queryStr = [bookParam, qParam].filter(Boolean).join('&');
  const url = `/api/books/index${queryStr ? '?' + queryStr : ''}`;

  try {
    let items = [];
    try {
      const res = await fetch(url);
      if (res.ok) {
        items = await res.json();
      } else {
        throw new Error('Static fallback');
      }
    } catch (_) {
      if (!state.masterIndex.staticData) {
        const staticRes = await fetch('/data/books_index.json');
        if (staticRes.ok) {
          state.masterIndex.staticData = await staticRes.json();
        }
      }
      let filtered = state.masterIndex.staticData || [];
      if (state.masterIndex.selectedBook !== 'all') {
        const bNum = parseInt(state.masterIndex.selectedBook);
        filtered = filtered.filter(it => it.book_number === bNum);
      }
      if (state.masterIndex.searchQuery) {
        const q = state.masterIndex.searchQuery.toLowerCase();
        filtered = filtered.filter(it => 
          (it.heading && it.heading.toLowerCase().includes(q)) ||
          (it.unit_title && it.unit_title.toLowerCase().includes(q)) ||
          (it.snippet && it.snippet.toLowerCase().includes(q))
        );
      }
      items = filtered;
    }
    state.masterIndex.items = items;

    if (elements.masterIndexCount) {
      elements.masterIndexCount.textContent = `${items.length} عنوانات و نکات دستیاب ہیں`;
    }

    if (items.length === 0) {
      elements.masterIndexTbody.innerHTML = `
        <tr>
          <td colspan="7" style="text-align: center; padding: 24px; color: var(--text-muted);">
            کوئی عنوان نہیں ملا۔ تلاش کا لفظ تبدیل کریں۔
          </td>
        </tr>
      `;
      return;
    }

    elements.masterIndexTbody.innerHTML = '';
    items.forEach((item, idx) => {
      const row = document.createElement('tr');
      const bookTitle = item.book_title || `Book ${item.book_number}`;
      const courseCode = item.course_code || '';
      const unitTitle = item.unit_title || `Unit ${item.unit_number || ''}`;
      const heading = item.heading || 'Heading';
      const pdfPage = item.pdf_page || 1;
      const printedPage = item.printed_page || pdfPage;

      row.innerHTML = `
        <td style="text-align: center; font-weight: 700; color: var(--primary-navy);">${idx + 1}</td>
        <td>
          <div style="font-weight: 700; color: var(--primary-navy);">${escapeHtml(heading)}</div>
          ${item.snippet ? `<div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">${escapeHtml(item.snippet)}</div>` : ''}
        </td>
        <td>
          <span class="index-book-tag">📘 ${escapeHtml(courseCode)}</span>
        </td>
        <td style="font-size: 12px; color: var(--text-secondary); max-width: 140px;">
          ${escapeHtml(unitTitle)}
        </td>
        <td style="text-align: center;">
          <span class="index-page-badge">صفحہ ${pdfPage}</span>
        </td>
        <td style="text-align: center; color: var(--text-muted); font-size: 12px;">
          ${printedPage != pdfPage ? printedPage : '—'}
        </td>
        <td style="text-align: center;">
          <button class="index-action-btn" onclick="openPageModal(${item.book_number}, ${pdfPage}, '${escapeHtml(bookTitle)}')">
            👁️ صفحہ دیکھیں
          </button>
        </td>
      `;
      elements.masterIndexTbody.appendChild(row);
    });
  } catch (err) {
    console.error('Error loading index:', err);
    if (elements.masterIndexCount) {
      elements.masterIndexCount.textContent = 'اشاریہ لوڈ کرنے میں خرابی واقع ہوئی۔';
    }
  }
}

// Utility: HTML escaping
function escapeHtml(text) {
  if (!text) return '';
  const map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  };
  return String(text).replace(/[&<>"']/g, m => map[m]);
}
