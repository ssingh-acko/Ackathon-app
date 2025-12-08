import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../launch_mission/crowdfund_mission_page.dart';
import '../launch_mission/model/launch_mission_data.dart';
import 'cubit.dart';
import 'model/incident_detail_model.dart';

// PAGE (REFAC TO CUBIT)
// ------------------------------------------------------------
class IncidentDetailsPage extends StatelessWidget {
  const IncidentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IncidentDetailsCubit()..fetchIncident(),
      child: const _IncidentDetailsView(),
    );
  }
}

class _IncidentDetailsView extends StatefulWidget {
  const _IncidentDetailsView();

  @override
  State<_IncidentDetailsView> createState() => _IncidentDetailsViewState();
}

class _IncidentDetailsViewState extends State<_IncidentDetailsView> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<IncidentDetailsCubit, IncidentDetailsState>(
          builder: (context, state) {
            if (state is IncidentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is IncidentError) {
              return Center(child: Text(state.message));
            }

            if (state is IncidentLoaded) {
              final data = state.data;
              return _buildContent(context, data, isDark);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, IncidentReport data, bool isDark) {
    return Column(
      children: [
        _buildTopBar(context, isDark),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                _buildTitleSection(data, isDark),
                const SizedBox(height: 20),
                _buildLocationLink(data, isDark),
                const SizedBox(height: 20),
                ..._buildImageCards(data),
                const SizedBox(height: 20),
                _buildDangerAndMetaCard(data, isDark),
                const SizedBox(height: 20),
                _buildTags(data),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),

        _buildBottomButtons(),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Pothole Incident Details",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 34),
        ],
      ),
    );
  }

  Widget _buildTitleSection(IncidentReport data, bool isDark) {
    return Column(
      children: [
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.publicSans(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Reported by: ${data.reporterName}",
          style: GoogleFonts.publicSans(
            fontSize: 14,
            color: isDark ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationLink(IncidentReport data, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, color: Colors.purple),
        const SizedBox(width: 4),
        Text(
          data.address,
          style: GoogleFonts.publicSans(
            color: Colors.purple,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildImageCards(IncidentReport data) {
    return List.generate(data.imageUrls.length, (i) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Image.network(data.imageUrls[i], fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                '"${data.imageCaptions[i]}"',
                style: GoogleFonts.publicSans(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDangerAndMetaCard(IncidentReport data, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: data.dangerInfo.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: data.dangerInfo.color.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: data.dangerInfo.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    data.dangerInfo.text.toUpperCase(),
                    style: GoogleFonts.publicSans(
                      color: data.dangerInfo.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          ...data.metadata.map((m) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Icon(m.icon, size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          m.label,
                          style: GoogleFonts.publicSans(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          m.value,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.publicSans(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: Colors.grey.withOpacity(0.2)),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTags(IncidentReport data) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: data.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE9D8FD),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            tag,
            style: GoogleFonts.publicSans(
              color: const Color(0xFF6F42C1),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButtons() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => CrowdfundMissionPage(
              data: CrowdfundMission(
                missionTitle: "Clean Garbage Dump at Maple Street",
                images: BeforeAfterImage(
                  beforeUrl:
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuC6P2UK5KTB7WxXGwT4SBJ8w3X7jl0vK1qxKq5Ys3y4s44l-p4X6l_ebfy3t1VB1RqFY_JyrX-FdcCOX2EYdLd8YwT4ppmttY1HerhSMUPmPiaTAYOTdx84J8teUx3mIz1zFPeemeVd-FIWXvJAkaBuaVavrF1svx5V_wIAE3xYM08N4hVsT6lslMK_GSJi4gJ7tynV7mCS6V2aF9iUcGNWNq-Cq_BlEwc5v_athoI01Vn2qPOKMBBriIGYXh-wUTVqyQTssy7xwsg",
                  afterUrl:
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuDICLJQ1FyojwZbJvtA97hTOOwLSdhwfwBnxIGx9lnoriQGtzmEnYElh21UYPSEVUvzUYr0elrpJ71JMWYR0KhpkDElXWEHe5vo5rVrXZe_Yd0QqYilVq_4nrklsKiJVOtLuovPQoRdagVKljIX26z2ibSsyiK4R9V10QLuT_xXMXASFMmhQY7r6gG2ohN0_KkXuXjdhwqMjwr-PRsvLvfKGnRlxw6loN5A5hyxAmft9ddtmiR-Tb9rhzb545KPIL6boNg6isXGXiM",
                ),
                aiBudget: 15000,
                aiEta: "3 Days",
                seedRequired: 1500,
                seedPercent: 10,
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Column(
          children: [
            Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF6D38FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  "Let's fix this",
                  style: GoogleFonts.publicSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
