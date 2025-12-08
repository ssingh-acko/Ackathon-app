import 'package:flutter/material.dart';

import 'model/pdp_page_model.dart';

class FundingHeroesPage extends StatelessWidget {
  final List<HeroContributor> heroesList;
  const FundingHeroesPage({super.key, required this.heroesList});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Funding Heroes"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF7F7FA),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: heroesList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final c = heroesList[index];

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(c.imageUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    c.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Text(
                  "₹${c.amount}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF6F3DFA),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
