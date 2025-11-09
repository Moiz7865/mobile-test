import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const FindItPkApp());
}

class FindItPkApp extends StatelessWidget {
  const FindItPkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindIt_PK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
      ),
      home: const HomeScreen(),
    );
  }
}

class Business {
  final String id;
  final String name;
  final String category;
  final String description;
  final String phone;
  final String whatsapp;
  final String city;
  final String imageUrl;
  final String mapsQuery;

  const Business({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.phone,
    required this.whatsapp,
    required this.city,
    required this.imageUrl,
    required this.mapsQuery,
  });
}

// Static mock data (no database / no local storage)
const List<Business> kBusinesses = [
  Business(
    id: '1',
    name: 'QuickFix Mobile Repair',
    category: 'Mobile Repair',
    description:
        'Professional mobile repair services for all major brands with same-day service.',
    phone: '+923001112233',
    whatsapp: '+923001112233',
    city: 'Karachi',
    imageUrl:
        'https://images.pexels.com/photos/4421522/pexels-photo-4421522.jpeg',
    mapsQuery: 'QuickFix Mobile Repair Karachi Pakistan',
  ),
  Business(
    id: '2',
    name: 'Alpha Home Tutor',
    category: 'Tutor',
    description:
        'Experienced tutors for Matric, Intermediate, and University level courses.',
    phone: '+923214445566',
    whatsapp: '+923214445566',
    city: 'Lahore',
    imageUrl:
        'https://images.pexels.com/photos/4144222/pexels-photo-4144222.jpeg',
    mapsQuery: 'Alpha Home Tutor Lahore Pakistan',
  ),
  Business(
    id: '3',
    name: 'Smart Plumbers',
    category: 'Plumber',
    description:
        'On-call plumbing solutions for homes and offices, available 24/7.',
    phone: '+923334445577',
    whatsapp: '+923334445577',
    city: 'Islamabad',
    imageUrl:
        'https://images.pexels.com/photos/5854187/pexels-photo-5854187.jpeg',
    mapsQuery: 'Smart Plumbers Islamabad Pakistan',
  ),
  Business(
    id: '4',
    name: 'FreshMart Grocery',
    category: 'Grocery',
    description:
        'Local grocery store offering fresh vegetables, fruits, and daily essentials.',
    phone: '+923455667788',
    whatsapp: '+923455667788',
    city: 'Karachi',
    imageUrl:
        'https://images.pexels.com/photos/3737592/pexels-photo-3737592.jpeg',
    mapsQuery: 'FreshMart Grocery Karachi Pakistan',
  ),
  Business(
    id: '5',
    name: 'City Tech Solutions',
    category: 'IT Services',
    description:
        'Software development, networking, and CCTV installation for small businesses.',
    phone: '+923218889900',
    whatsapp: '+923218889900',
    city: 'Lahore',
    imageUrl:
        'https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg',
    mapsQuery: 'City Tech Solutions Lahore Pakistan',
  ),
];

const List<String> kCategories = [
  'All',
  'Mobile Repair',
  'Tutor',
  'Plumber',
  'Grocery',
  'IT Services',
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filtered = kBusinesses.where((b) {
      final matchesCategory =
          selectedCategory == 'All' || b.category == selectedCategory;
      final query = searchQuery.toLowerCase().trim();
      final matchesQuery = query.isEmpty ||
          b.name.toLowerCase().contains(query) ||
          b.description.toLowerCase().contains(query) ||
          b.city.toLowerCase().contains(query) ||
          b.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FindIt_PK'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _HeaderSection(onSearchChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            }),
            _CategoryChips(
              categories: kCategories,
              selected: selectedCategory,
              onSelected: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No results found.',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.outline),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // Simple responsiveness for wider screens
                        final isWide = constraints.maxWidth >= 700;
                        if (isWide) {
                          final crossAxisCount =
                              (constraints.maxWidth ~/ 320).clamp(2, 4);
                          return GridView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 3 / 2,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final business = filtered[index];
                              return _BusinessCard(
                                business: business,
                                onTap: () => _openDetails(business),
                              );
                            },
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final business = filtered[index];
                            return _BusinessCard(
                              business: business,
                              onTap: () => _openDetails(business),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(Business business) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BusinessDetailScreen(business: business),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const _HeaderSection({required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover local services near you',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by name, category, or city',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
            onChanged: onSearchChanged,
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selected;
          return ChoiceChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (_) => onSelected(cat),
            labelStyle: theme.textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
            selectedColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surfaceVariant,
          );
        },
      ),
    );
  }
}

class _BusinessCard extends StatelessWidget {
  final Business business;
  final VoidCallback onTap;

  const _BusinessCard({
    required this.business,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  business.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.storefront,
                      size: 32,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${business.category} • ${business.city}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      business.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessDetailScreen extends StatelessWidget {
  final Business business;

  const BusinessDetailScreen({super.key, required this.business});

  Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final clean = phone.replaceAll('+', '').replaceAll(' ', '');
    final uri = Uri.parse('https://wa.me/$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchMaps(String query) async {
    final encoded = Uri.encodeComponent(query);
    final uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(business.name),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  business.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.storefront,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              business.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${business.category} • ${business.city}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              business.description,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'Contact',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  business.phone,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  business.city,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.call),
                  label: const Text('Call'),
                  onPressed: () => _launchPhone(business.phone),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.whatsapp),
                  label: const Text('WhatsApp'),
                  onPressed: () => _launchWhatsApp(business.whatsapp),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Get Directions'),
                  onPressed: () => _launchMaps(business.mapsQuery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}