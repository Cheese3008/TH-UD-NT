import 'package:flutter/material.dart';
import 'tile.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LAB 1 Flutter',
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget
{
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF6F0FF),
              Color(0xFFEAF4FF),
              Color(0xFFFDFBFF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 430,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 30,
                        offset: Offset(0, 14),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFE9E9F2),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF5B8CFF),
                              Color(0xFF7B61FF),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x335B8CFF),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.flutter_dash,
                          size: 46,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Welcome to My Flutter App',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFFE5EAF2),
                          ),
                        ),
                        child: const Column(
                          children: [
                            InfoRow(
                              icon: Icons.person_outline,
                              label: 'Họ và tên',
                              value: 'Lê Nguyễn Bảo Trân',
                            ),
                            SizedBox(height: 14),
                            InfoRow(
                              icon: Icons.badge_outlined,
                              label: 'MSSV',
                              value: '2224802010476',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Center(
                        child: HoverLabButton(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget
{
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context)
  {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HoverLabButton extends StatefulWidget
{
  const HoverLabButton({super.key});

  @override
  State<HoverLabButton> createState() => _HoverLabButtonState();
}

class _HoverLabButtonState extends State<HoverLabButton>
{
  bool isHovering = false;

  @override
  Widget build(BuildContext context)
  {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovering = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 220,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isHovering
                ? const [
                    Color(0xFFFF8A00),
                    Color(0xFFFFC444),
                  ]
                : const [
                    Color(0xFF5B8CFF),
                    Color(0xFF7B61FF),
                  ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isHovering
              ? const [
                  BoxShadow(
                    color: Color(0x33FF8A00),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ]
              : const [],
        ),
        child: const Center(
          child: Text(
            'LAB 1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}