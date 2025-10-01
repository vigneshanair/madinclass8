import 'package:flutter/material.dart';

void main() => runApp(const RootApp());

/// ---------------------------- THEME & ROOT ----------------------------
class RootApp extends StatefulWidget {
  const RootApp({super.key});
  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  ThemeMode _mode = ThemeMode.light;

  // Pick one vibe below by changing the seed color if you want:
  // static const seed = Color(0xFF3D5A80); // navy slate
  // static const seed = Color(0xFF2D6A4F); // deep emerald
  static const seed = Color(0xFF5B5F97); // indigo-violet (modern, calm)

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
    final dark = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fading Text Animation',
      theme: light,
      darkTheme: dark,
      themeMode: _mode,
      home: HomePager(
        onToggleTheme: _toggleTheme,
        isDark: _mode == ThemeMode.dark,
      ),
    );
  }
}

/// ---------------------------- PAGE VIEW WRAPPER ----------------------------
class HomePager extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;
  const HomePager({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<HomePager> createState() => _HomePagerState();
}

class _HomePagerState extends State<HomePager> {
  final _pageController = PageController();
  Color _textColor = const Color(0xFFCA2B5A); // headline color
  bool _showFrame = false; // toggle frame around the hero card

  void _pickColor() async {
    // Simple built-in color picker (no packages)
    final colors = <Color>[
      const Color(0xFFCA2B5A), // rose
      const Color(0xFF2E7D73), // teal
      const Color(0xFF3D5A80), // navy slate
      const Color(0xFFEE6C4D), // coral
      const Color(0xFF2D6A4F), // deep emerald
      Colors.indigo,
      Colors.purple,
      Colors.orange,
      Colors.amber,
      Colors.brown,
      Colors.grey,
      Colors.black,
    ];

    final chosen = await showDialog<Color>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pick title color'),
        content: SizedBox(
          width: 280,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: colors.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (_, i) => InkWell(
              onTap: () => Navigator.pop(ctx, colors[i]),
              child: Container(
                decoration: BoxDecoration(
                  color: colors[i],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (chosen != null) setState(() => _textColor = chosen);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fading Text Animation'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Pick Title Color',
            icon: const Icon(Icons.palette),
            onPressed: _pickColor,
          ),
          IconButton(
            tooltip: 'Toggle Day/Night',
            icon: Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          FadePageBasic(
            textColor: _textColor,
            showFrame: _showFrame,
            onToggleFrame: (v) => setState(() => _showFrame = v),
          ),
          const FadePageAdvanced(),
        ],
      ),
    );
  }
}

/// ---------------------------- PAGE 1: FANCY HERO + FADE ----------------------------
class FadePageBasic extends StatefulWidget {
  final Color textColor;
  final bool showFrame;
  final ValueChanged<bool> onToggleFrame;

  const FadePageBasic({
    super.key,
    required this.textColor,
    required this.showFrame,
    required this.onToggleFrame,
  });

  @override
  State<FadePageBasic> createState() => _FadePageBasicState();
}

class _FadePageBasicState extends State<FadePageBasic> {
  bool _visible = true;

  void _toggle() => setState(() => _visible = !_visible);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Headline that fades
              GestureDetector(
                onTap: _toggle,
                child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeInOut,
                  child: Text(
                    'Hello, Flutter!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: widget.textColor,
                      letterSpacing: .2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Frame toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Show Frame',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Switch(
                    value: widget.showFrame,
                    onChanged: widget.onToggleFrame,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Hero card (no network/assets)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      scheme.primaryContainer.withOpacity(.95),
                      scheme.secondaryContainer.withOpacity(.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: widget.showFrame
                      ? Border.all(color: scheme.primary, width: 3)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withOpacity(.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: _blob(
                        color: scheme.primary.withOpacity(.15),
                        size: 180,
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: -20,
                      child: _blob(
                        color: scheme.secondary.withOpacity(.18),
                        size: 140,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '✨',
                            style: TextStyle(
                              fontSize: 42,
                              shadows: [
                                Shadow(
                                  color: scheme.primary.withOpacity(.3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Animated Showcase',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: scheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text(
                "Tip: Tap the title or press the button to fade it. Use the palette in the top bar to change color. "
                "Swipe to page 2 to compare animation curves and read a short practice guide.",
                style: TextStyle(color: scheme.outline),
              ),
            ],
          ),
        ),

        // Play / Pause FAB
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _toggle,
            child: Icon(_visible ? Icons.pause : Icons.play_arrow),
          ),
        ),
      ],
    );
  }

  Widget _blob({required Color color, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}

/// ---------------------------- PAGE 2: SHORT GUIDE + DIFFERENT CURVE ----------------------------
class FadePageAdvanced extends StatefulWidget {
  const FadePageAdvanced({super.key});

  @override
  State<FadePageAdvanced> createState() => _FadePageAdvancedState();
}

class _FadePageAdvancedState extends State<FadePageAdvanced> {
  bool _visible = true;
  void _toggle() => setState(() => _visible = !_visible);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: AnimatedOpacity(
                    opacity: _visible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 2200),
                    curve: Curves.easeOutCubic,
                    child: Text(
                      'Smooth & Slow Fade',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Practice Guide (Short)",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),

                _step(
                  "1",
                  "Use the button to fade text. Notice the relaxed 2.2s ease-out curve.",
                ),
                _step(
                  "2",
                  "Try other curves (easeIn, linear) and pick what fits the mood.",
                ),
                _step(
                  "3",
                  "Keep animations subtle: short text, clear contrast, smooth timing.",
                ),

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer.withOpacity(.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: scheme.secondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Tip: Ease-out curves feel natural for elements fading in.",
                          style: TextStyle(color: scheme.onSecondaryContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: _toggle,
              icon: Icon(_visible ? Icons.pause : Icons.play_arrow),
              label: Text(_visible ? "Fade Out" : "Fade In"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step(String n, String t) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withOpacity(.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          child: Text(n),
        ),
        title: Text(t, style: const TextStyle(height: 1.4)),
      ),
    );
  }
}
