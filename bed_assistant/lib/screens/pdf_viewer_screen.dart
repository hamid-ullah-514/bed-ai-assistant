import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class PdfViewerScreen extends StatefulWidget {
  final int bookNumber;
  final String bookTitle;
  final int initialPage;

  const PdfViewerScreen({
    super.key,
    required this.bookNumber,
    required this.bookTitle,
    this.initialPage = 1,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController _pdfViewerController;
  String _pdfUrl = '';
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  int _pageCount = 1;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pdfViewerController = PdfViewerController();
    _loadPdfUrl();
  }

  Future<void> _loadPdfUrl() async {
    try {
      final url = await ApiService.getPdfStreamUrl(widget.bookNumber);
      if (mounted) {
        setState(() {
          _pdfUrl = url;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load PDF URL: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _showJumpDialog() {
    final textController = TextEditingController(text: '$_currentPage');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Jump to Page'),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Page Number',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final p = int.tryParse(textController.text.trim());
              if (p != null && p > 0) {
                _pdfViewerController.jumpToPage(p);
                setState(() => _currentPage = p);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    final searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Search in Document'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search keyword...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = searchController.text.trim();
              if (text.isNotEmpty) {
                _pdfViewerController.searchText(text);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PDF Viewer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDarkNavy),
            ),
            Text(
              'Book ${widget.bookNumber} - Page $_currentPage',
              style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tag),
            tooltip: 'Jump to Page',
            onPressed: _showJumpDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.info_outline, size: 48, color: AppColors.primaryMintGreen),
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 13, color: AppColors.primaryDarkNavy),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryMintGreen,
                                      foregroundColor: Colors.white,
                                    ),
                                    icon: const Icon(Icons.refresh, size: 16),
                                    label: const Text('دوبارہ کوشش کریں (Retry)'),
                                    onPressed: () {
                                      setState(() {
                                        _errorMessage = null;
                                        _isLoading = true;
                                      });
                                      _loadPdfUrl();
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.image, size: 16),
                                    label: const Text('صفحہ کی تصویر دیکھیں'),
                                    onPressed: () async {
                                      final imgUrl = await ApiService.getPageImageUrl(widget.bookNumber, _currentPage);
                                      if (mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => Dialog(
                                            child: InteractiveViewer(
                                              child: Image.network(
                                                imgUrl,
                                                loadingBuilder: (c, child, progress) {
                                                  if (progress == null) return child;
                                                  return const Center(child: CircularProgressIndicator());
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : SfPdfViewer.network(
                        _pdfUrl,
                        controller: _pdfViewerController,
                        initialPageNumber: widget.initialPage,
                        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                          setState(() {
                            _pageCount = details.document.pages.count;
                          });
                          if (widget.initialPage > 1) {
                            _pdfViewerController.jumpToPage(widget.initialPage);
                          }
                        },
                        onPageChanged: (PdfPageChangedDetails details) {
                          setState(() {
                            _currentPage = details.newPageNumber;
                          });
                        },
                        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                          setState(() {
                            _errorMessage = 'کتاب لوڈ ہونے میں وقت لگا: ${details.description}\nآپ براہِ راست صفحہ نمبر $_currentPage کی تصویر دیکھ سکتے ہیں۔';
                          });
                        },
                      ),
          ),

          // Bottom Controls Bar (Matching Screen 15)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.lightBorder)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page indicator: 24 / 249
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.lightMintBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_currentPage / $_pageCount',
                    style: const TextStyle(
                      color: AppColors.primaryMintGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 24),
                      onPressed: () => _pdfViewerController.previousPage(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 24),
                      onPressed: () => _pdfViewerController.nextPage(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, size: 20),
                      onPressed: _showSearchDialog,
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_in, size: 20),
                      onPressed: () => _pdfViewerController.zoomLevel += 0.25,
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_out, size: 20),
                      onPressed: () => _pdfViewerController.zoomLevel -= 0.25,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
