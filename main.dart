
import 'package:flutter/material.dart';

void main() => runApp(const PatooqApp());

const gold = Color(0xFFD6B56D);
const bg = Color(0xFF090A0D);
const panel = Color(0xFF15171D);
const muted = Color(0xFF9296A1);

class PatooqApp extends StatelessWidget {
  const PatooqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patooq 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: gold, secondary: gold, surface: panel,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: bg, foregroundColor: Colors.white,
          elevation: 0, centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: panel,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class Post {
  Post({required this.user, required this.handle, required this.caption,
    required this.time, this.likes = 0, this.liked = false,
    this.symbol = '✨'});
  final String user, handle, caption, time, symbol;
  int likes;
  bool liked;
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  final posts = <Post>[
    Post(user: 'آرمان', handle: '@arman', caption: 'شروعی تازه، تجربه‌ای تازه در پاتوق ۲ 🌙',
      time: '۱۰ دقیقه پیش', likes: 128, symbol: '🌃'),
    Post(user: 'نگار', handle: '@negar', caption: 'گاهی یک فنجان قهوه و کمی آرامش کافی است ☕',
      time: '۳۵ دقیقه پیش', likes: 86, symbol: '☕'),
    Post(user: 'پارسا', handle: '@parsa', caption: 'امشب برای ساختن رویاها وقت خوبی است.',
      time: '۱ ساعت پیش', likes: 54, symbol: '🌌'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(posts: posts, onChanged: () => setState(() {})),
      const ExplorePage(),
      const MessagesPage(),
      const ProfilePage(),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      floatingActionButton: tab == 0 ? FloatingActionButton(
        backgroundColor: gold, foregroundColor: bg,
        onPressed: _compose, child: const Icon(Icons.add, size: 29),
      ) : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        backgroundColor: const Color(0xFF101116),
        indicatorColor: gold.withOpacity(.16),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'خانه'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'کاوش'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'پیام‌ها'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'پروفایل'),
        ],
      ),
    );
  }

  void _compose() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: panel,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 22, 20, MediaQuery.of(ctx).viewInsets.bottom + 22),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('پست جدید', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: controller, maxLines: 4, decoration: const InputDecoration(hintText: 'چه چیزی در ذهن داری؟')),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => posts.insert(0, Post(user: 'کاربر پاتوق', handle: '@you',
                  caption: controller.text.trim(), time: 'همین الان', symbol: '💬')));
                Navigator.pop(ctx);
              }
            },
            child: const Text('انتشار پست'),
          )),
        ]),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.posts, required this.onChanged});
  final List<Post> posts;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverAppBar(
        pinned: true, title: const Row(children: [
          Text('patooq', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -.8)),
          Text('  2.0', style: TextStyle(color: gold, fontSize: 14, fontWeight: FontWeight.bold)),
        ]),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)), const SizedBox(width: 8)],
      ),
      SliverToBoxAdapter(child: _stories()),
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('آخرین پست‌ها', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('برای تو', style: TextStyle(color: gold.withOpacity(.9))),
        ]),
      )),
      SliverList(delegate: SliverChildBuilderDelegate(
        (context, i) => PostCard(post: posts[i], onChanged: onChanged),
        childCount: posts.length,
      )),
      const SliverToBoxAdapter(child: SizedBox(height: 90)),
    ],
  );

  Widget _stories() {
    final names = ['داستان شما', 'نگار', 'آرمان', 'سارا', 'پارسا', 'رها'];
    final emojis = ['＋', '🌷', '🦁', '🌙', '🎧', '🪷'];
    return SizedBox(height: 112, child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      scrollDirection: Axis.horizontal, itemCount: names.length,
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemBuilder: (_, i) => SizedBox(width: 62, child: Column(children: [
        Container(
          width: 62, height: 62, padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(shape: BoxShape.circle,
            border: Border.all(color: i == 0 ? muted : gold, width: 1.8)),
          child: CircleAvatar(backgroundColor: const Color(0xFF252833),
            child: Text(emojis[i], style: const TextStyle(fontSize: 24))),
        ),
        const SizedBox(height: 6),
        Text(names[i], maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ])),
    ));
  }
}

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, required this.onChanged});
  final Post post;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(14, 7, 14, 10),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(.045))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: const CircleAvatar(backgroundColor: Color(0xFF34313A), child: Icon(Icons.person, color: gold)),
        title: Text(post.user, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${post.handle} • ${post.time}', style: const TextStyle(color: muted, fontSize: 11)),
        trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        height: 190, width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF292832), Color(0xFF171922), Color(0xFF332B20)]),
        ),
        child: Center(child: Text(post.symbol, style: const TextStyle(fontSize: 68))),
      ),
      Padding(padding: const EdgeInsets.fromLTRB(16, 13, 16, 4),
        child: Text(post.caption, style: const TextStyle(fontSize: 14, height: 1.7))),
      Padding(padding: const EdgeInsets.fromLTRB(8, 2, 8, 8), child: Row(children: [
        IconButton(
          onPressed: () { post.liked = !post.liked; post.likes += post.liked ? 1 : -1; onChanged(); },
          icon: Icon(post.liked ? Icons.favorite : Icons.favorite_border,
            color: post.liked ? Colors.redAccent : Colors.white70),
        ),
        Text('${post.likes}', style: const TextStyle(color: muted, fontSize: 12)),
        IconButton(onPressed: () => _comment(context), icon: const Icon(Icons.mode_comment_outlined, color: Colors.white70)),
        const Text('نظر بده', style: TextStyle(color: muted, fontSize: 12)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border, color: Colors.white70)),
      ])),
    ]),
  );

  void _comment(BuildContext context) {
    showModalBottomSheet(context: context, backgroundColor: panel, builder: (_) => const Padding(
      padding: EdgeInsets.all(24), child: Text('بخش نظرات در نسخه نمایشی آماده اتصال به سرور است.'),
    ));
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Padding(
    padding: EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.explore, color: gold, size: 54), SizedBox(height: 14),
      Text('کاوش در پاتوق', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      SizedBox(height: 8), Text('جست‌وجوی کاربران و موضوعات محبوب در نسخه بعدی به سرور متصل می‌شود.',
        textAlign: TextAlign.center, style: TextStyle(color: muted, height: 1.7)),
    ]),
  ));
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      const Text('پیام‌ها', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      for (final item in ['نگار', 'آرمان', 'سارا'])
        ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFF34313A), child: Icon(Icons.person, color: gold)),
          title: Text(item), subtitle: const Text('گفت‌وگو در نسخه نمایشی'),
          trailing: const Icon(Icons.chevron_right),
        ),
    ],
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const SizedBox(height: 18),
    const Center(child: CircleAvatar(radius: 46, backgroundColor: Color(0xFF34313A),
      child: Icon(Icons.person, size: 48, color: gold))),
    const SizedBox(height: 12),
    const Center(child: Text('کاربر پاتوق', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
    const Center(child: Text('@you', style: TextStyle(color: muted))),
    const SizedBox(height: 22),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
      _Stat(value: '12', label: 'پست'), _Stat(value: '340', label: 'دنبال‌کننده'), _Stat(value: '180', label: 'دنبال‌شونده'),
    ]),
    const SizedBox(height: 24),
    FilledButton.tonal(onPressed: () {}, child: const Text('ویرایش پروفایل')),
    const SizedBox(height: 12),
    const Card(color: panel, child: ListTile(leading: Icon(Icons.settings_outlined, color: gold),
      title: Text('تنظیمات'), trailing: Icon(Icons.chevron_right))),
  ]);
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value, label;
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    Text(label, style: const TextStyle(color: muted, fontSize: 12)),
  ]);
}
