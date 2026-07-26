// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAonuP85TxCUTInW1RtSxHA6rGek-_ulyI",
      authDomain: "contentflow-amin-cap.firebaseapp.com",
      projectId: "contentflow-amin-cap",
      storageBucket: "contentflow-amin-cap.firebasestorage.app",
      messagingSenderId: "903771306287",
      appId: "1:903771306287:web:d8cf2cc4eeb10c7ff589da",
      measurementId: "G-7Y06N6FWFH",
    ),
  );

  runApp(const ContentFlowApp());
}

class ContentFlowApp extends StatelessWidget {
  const ContentFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContentFlow Creator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4B156B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B156B),
          secondary: const Color(0xFFF5B800),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F5F7),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

/// Gatekeeper Log Masuk
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return CreatorHomeScreen(user: snapshot.data!);
        }
        return const CreatorLoginScreen();
      },
    );
  }
}

/// Skrin Log Masuk
class CreatorLoginScreen extends StatefulWidget {
  const CreatorLoginScreen({Key? key}) : super(key: key);

  @override
  State<CreatorLoginScreen> createState() => _CreatorLoginScreenState();
}

class _CreatorLoginScreenState extends State<CreatorLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.message ?? 'Log masuk gagal');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Ralat tidak dijangka berlaku.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B156B),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 12, offset: Offset(0, 4))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5B800),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'AMIN CAP',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'ContentFlow',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4B156B)),
                ),
                const Text('Creator Mobile App',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 28),
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(_errorMessage!,
                        style: TextStyle(
                            color: Colors.red.shade700, fontSize: 12)),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mel',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Kata Laluan',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B156B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Log Masuk',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Skrin Utama Creator
class CreatorHomeScreen extends StatefulWidget {
  final User user;
  const CreatorHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<CreatorHomeScreen> createState() => _CreatorHomeScreenState();
}

class _CreatorHomeScreenState extends State<CreatorHomeScreen> {
  String _selectedFilter = 'All';
  String _displayName = '';

  final List<String> _filters = [
    'All',
    'Assigned',
    'Pending Review',
    'Revision Requested',
    'Approved'
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() {
    if (widget.user.displayName != null &&
        widget.user.displayName!.isNotEmpty) {
      _displayName = widget.user.displayName!;
    } else if (widget.user.email != null) {
      final email = widget.user.email!.toLowerCase();
      if (email.contains('mior')) {
        _displayName = 'Mior';
      } else if (email.contains('aina')) {
        _displayName = 'Aina';
      } else {
        final raw = email.split('@')[0];
        _displayName = raw[0].toUpperCase() + raw.substring(1);
      }
    } else {
      _displayName = 'Creator';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hai, $_displayName 👋',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const Text('Tugasan & Sasaran 150 Video',
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF4B156B),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Log Keluar',
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        // REALTIME STREAM: Listens to any update instantly from Firestore/Web
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text('Ralat Firestore: ${snapshot.error}'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allDocs = snapshot.data?.docs ?? [];

          // 1. Calculate Metrics for All Tasks
          int myTotalAssigned = 0;
          int myApprovedCount = 0;
          int teamApprovedCount = 0;
          Map<String, int> myPlatformCounts = {};

          for (var doc in allDocs) {
            final data = doc.data();
            final status = (data['status'] ?? '').toString().toLowerCase();
            final assignedName =
                (data['assignedToName'] ?? '').toString().toLowerCase();
            final assignedUid = (data['assignedToUid'] ?? '').toString();
            final assignedEmail = (data['assignedToEmail'] ?? '').toString();
            final platform =
                (data['platform'] ?? 'Video').toString().toUpperCase();

            // Broad check to ensure web tasks aren't missed
            final isMyTask = assignedUid == widget.user.uid ||
                assignedEmail == widget.user.email ||
                assignedName.contains(_displayName.toLowerCase());

            final isApproved = status == 'approved' || status == 'completed';

            if (isApproved) {
              teamApprovedCount++;
            }

            if (isMyTask) {
              myTotalAssigned++;
              if (isApproved) {
                myApprovedCount++;
                myPlatformCounts[platform] =
                    (myPlatformCounts[platform] ?? 0) + 1;
              }
            }
          }

          // 2. Filter tasks assigned specifically to current creator
          var myDocs = allDocs.where((doc) {
            final data = doc.data();
            final assignedName =
                (data['assignedToName'] ?? '').toString().toLowerCase();
            final assignedUid = (data['assignedToUid'] ?? '').toString();
            final assignedEmail = (data['assignedToEmail'] ?? '').toString();

            return assignedUid == widget.user.uid ||
                assignedEmail == widget.user.email ||
                assignedName.contains(_displayName.toLowerCase());
          }).toList();

          // 3. Remove system dummy records
          myDocs = myDocs.where((doc) {
            final data = doc.data();
            return data['title'] != 'Task headline' &&
                data['assignedToName'] !=
                    "Matches creator's exact name in users collection";
          }).toList();

          // 4. Status Filtering
          var filteredDocs = myDocs;
          if (_selectedFilter != 'All') {
            filteredDocs = myDocs.where((doc) {
              final status =
                  (doc.data()['status'] ?? '').toString().toLowerCase();
              final filterTarget =
                  _selectedFilter.toLowerCase().replaceAll(' ', '_');
              return status == filterTarget ||
                  status == _selectedFilter.toLowerCase();
            }).toList();
          }

          return Column(
            children: [
              // Dashboard Summary Card (Shows total assigned & progress)
              DashboardSummaryCard(
                myTotalAssigned: myTotalAssigned,
                myApproved: myApprovedCount,
                teamApproved: teamApprovedCount,
                platformCounts: myPlatformCounts,
              ),

              // Horizontal Status Filter Chips
              Container(
                height: 50,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(
                          filter,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF4B156B),
                        checkmarkColor: Colors.white,
                        backgroundColor: const Color(0xFFF4F5F7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) _selectedFilter = filter;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              // Task List Display
              Expanded(
                child: filteredDocs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library_outlined,
                                size: 54, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text('Tiada video dalam status "$_selectedFilter"',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final data = filteredDocs[index].data();
                          final docId = filteredDocs[index].id;
                          return ContentCreatorCard(taskId: docId, data: data);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Dashboard Summary Card
class DashboardSummaryCard extends StatelessWidget {
  final int myTotalAssigned;
  final int myApproved;
  final int teamApproved;
  final Map<String, int> platformCounts;

  const DashboardSummaryCard({
    Key? key,
    required this.myTotalAssigned,
    required this.myApproved,
    required this.teamApproved,
    required this.platformCounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double myProgress = (myApproved / 150).clamp(0.0, 1.0);
    final double teamProgress = (teamApproved / 300).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row Header displaying Total Tasks Assigned
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '📊 Status Ringkasan Tugasan',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B156B)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5B800).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Diterima: $myTotalAssigned Video',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),

          // Individual Target Bar (150 Target)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Disiapkan: $myApproved / 150 Video',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
              Text('${(myProgress * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B156B))),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: myProgress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: const Color(0xFFF4F5F7),
            color: const Color(0xFF4B156B),
          ),

          const SizedBox(height: 10),

          // Team Target Bar (300 Target)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Keseluruhan Pasukan: $teamApproved / 300 Video',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey)),
              Text('${(teamProgress * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5B800))),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: teamProgress,
            minHeight: 5,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: const Color(0xFFF4F5F7),
            color: const Color(0xFFF5B800),
          ),

          // Platform Badge Breakdown
          if (platformCounts.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: platformCounts.entries.map((entry) {
                return Chip(
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: const Color(0xFF4B156B).withOpacity(0.06),
                  label: Text(
                    '${entry.key}: ${entry.value} Selesai',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B156B)),
                  ),
                );
              }).toList(),
            ),
          ]
        ],
      ),
    );
  }
}

/// Kad Tugasan Video
class ContentCreatorCard extends StatelessWidget {
  final String taskId;
  final Map<String, dynamic> data;

  const ContentCreatorCard({
    Key? key,
    required this.taskId,
    required this.data,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return Colors.purple.shade700;
      case 'pending_review':
        return Colors.blue.shade700;
      case 'revision_requested':
        return Colors.amber.shade800;
      case 'approved':
      case 'completed':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Future<void> _toggleSubtask(int index, List subtasks) async {
    subtasks[index]['completed'] = !(subtasks[index]['completed'] ?? false);
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({'subtasks': subtasks});
  }

  void _showSubmitDialog(BuildContext context) {
    final controller = TextEditingController(text: data['mediaUrl'] ?? '');
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Hantar Pautan Video'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Tampal pautan Google Drive, Canva, atau Video untuk semakan:',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: 'https://...', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B156B)),
            onPressed: () async {
              final url = controller.text.trim();
              if (url.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(taskId)
                    .update({
                  'mediaUrl': url,
                  'status': 'pending_review',
                });
                if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              }
            },
            child: const Text('Hantar Semakan',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = data['title'] ?? 'Tanpa Tajuk';
    final platform = data['platform'] ?? 'Video';
    final status = data['status'] ?? 'assigned';
    final scheduledDate = data['scheduledDate'] ?? 'Tiada Tarikh';
    final List subtasks = data['subtasks'] ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Platform Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B156B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    platform.toString().toUpperCase(),
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B156B)),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toString().replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(status)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('📅 Tarikh Publish: $scheduledDate',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),

            // Subtasks Checklist
            if (subtasks.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Kemajuan Prosedur Video:',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
              const SizedBox(height: 6),
              Column(
                children: List.generate(subtasks.length, (index) {
                  final item = subtasks[index];
                  final isDone = item['completed'] == true;
                  return InkWell(
                    onTap: () => _toggleSubtask(index, subtasks),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        children: [
                          Icon(
                            isDone
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 18,
                            color: isDone ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item['title'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              decoration:
                                  isDone ? TextDecoration.lineThrough : null,
                              color: isDone ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE4E6EB)),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (data['mediaUrl'] != null &&
                    data['mediaUrl'].toString().isNotEmpty)
                  const Text('✅ Link Dihantar',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold))
                else
                  const Text('⚠️ Belum Hantar Link',
                      style: TextStyle(fontSize: 12, color: Colors.orange)),
                ElevatedButton.icon(
                  onPressed: () => _showSubmitDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B156B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(100, 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  icon: const Icon(Icons.upload_file, size: 14),
                  label:
                      const Text('Hantar Link', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
