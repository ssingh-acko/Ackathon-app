import 'package:flutter/material.dart';

class FundingHeroesPage extends StatelessWidget {
  const FundingHeroesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final contributors = [
      Contributor(
        name: "Ravi S.",
        amount: 1500,
        image:
        "https://lh3.googleusercontent.com/aida-public/AB6AXuB_HzNluTp57gjem_RNdnMRS5AhDJzqUhQiUYv27Gbdj4z6RQFjRSUSKpObxN-we9uTVZTtEKkboipDKHbO2N2TMQKyl7ij1MYl7iRS3o4YGwz5tN3whRtllPhcC7RjlHiQyz5qmBMhpGQnWksMUlqJu5KT3f1ohTvTxeEtaI-z9k93DsatqhhPShWvHV1ky6G0lGlUOewA1TC8ofrYu6swOdYNhH1hQkeKEd3PZFyhbaf3yTJN2canHwFpfmLtt4qtWc5tUTtEpeY",
      ),
      Contributor(
        name: "Priya K.",
        amount: 2500,
        image:
        "https://lh3.googleusercontent.com/aida-public/AB6AXuBsUmTH8tGkVM2TNPV9WJwOXELDLnE0oH9jaDUzzMiNG1VbJ1KDmXSajzTB6y3erC-6FjZ-LLKDkh82KlRl4D89EUEVzIFR1R3SvLfjxMXcUA_ScKcaAVmWGiEZ9GyFi-qOxFz-1xEqOnPAj5y85gIPgjhQiT1JOyYP39xoHgB0olgQnBjoEgXKETB1M7cU7aFXIT_OgknBuULnwXgnYEQxk6x4b7dK1TYrsbIb_JDCqr5ZLCXQqG0acyqTXPVCtRhYWW79yCBlYC4",
      ),
      Contributor(
        name: "Ankit G.",
        amount: 500,
        image:
        "https://lh3.googleusercontent.com/aida-public/AB6AXuDljAf8ycQrNZdrqAJ_qzPFbp_XeeYFV2aV6IKk9C5OCNQJ7IhwZgjVQ1MhWp5Or6LWQlcWxsVwpiSMv-9r78vVWhNqOeYyuk6MlHbfuXX0C78m6CknY1kXr8zSr6TfZue-FDmyZuggmr-5d_ns7DQWr5YcriO4cudBsnsv0QH6xfWfmPfdYme1nmYbk8UJdPPdLto3qwU5qTaYv1cptmGhpVQTEk_4PlQSzikqmwSjPlR08A1LvqjcngUVCx9plP2K9vMX2Yjcuv4",
      ),
    ];

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
        itemCount: contributors.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final c = contributors[index];

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
                  backgroundImage: NetworkImage(c.image),
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

class Contributor {
  final String name;
  final int amount;
  final String image;

  Contributor({
    required this.name,
    required this.amount,
    required this.image,
  });
}

