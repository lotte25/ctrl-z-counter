import 'package:ctrlz_counter/utils/utils.dart';
import 'package:ctrlz_counter/widgets/buttons/icon_only_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

void showInfoDialog({
  required BuildContext context
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 350,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  child: Image.asset(
                    "assets/images/gatologo.png",
                    width: 100,
                    height: 100,
                  )
                ),
                SizedBox(height: 5),
                Text(
                  "Ctrl + Z Counter",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface
                  ),
                ),
                FutureBuilder(
                  future: getProgramVersion(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Text(
                        "Version ${snapshot.data}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface.withValues(alpha: 0.8)
                        )
                      );
                    }
                  }
                ),
                SizedBox(height: 10),
                Text(
                  "A program that counts every Ctrl + Z.",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: colorScheme.onSurface
                  )
                ),
                const Divider(),
                ElevatedButton.icon(
                  onPressed: () async {
                    final url = "https://github.com/lotte25/ctrl-z-counter";

                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    }
                  }, 
                  label: Text("Repository"),
                  icon: Icon(MdiIcons.github)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Credits",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: colorScheme.onSurface
                      )
                    ),
                  ]
                ),
                PersonCard(
                  colorScheme: colorScheme,
                  profileImage: "https://avatars.githubusercontent.com/u/61674780",
                  personName: "lotte25",
                  personRole: "Main developer",
                  personURL: "https://github.com/lotte25"
                ),
                PersonCard(
                  colorScheme: colorScheme, 
                  profileImage: "assets/images/shary.png", 
                  imageType: "asset",
                  personName: "Kandell", 
                  personRole: "Support and inspiration",
                  personURL: "https://x.com/SternKennArt",
                )
              ],
            ),
          ),
        ),
      );
    }
  );
}


class PersonCard extends StatelessWidget {
  final dynamic profileImage;
  final String? imageType;
  final String personName;
  final String personRole;
  final String? personURL;
  
  const PersonCard({
    super.key,
    required this.colorScheme, 
    required this.profileImage, 
    this.imageType = "network",
    required this.personName, 
    required this.personRole, 
    this.personURL, 
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 70,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          spacing: 5,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              child: (imageType == "asset" ? Image.asset : Image.network)(
                profileImage,
                width: 50,
                height: 50,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  personName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  personRole,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (personURL != null) IconOnlyButton(icon: Icon(Icons.link), onPressed: () async {
              final url = personURL;
    
              if (await canLaunchUrlString(url!)) {
                await launchUrlString(url);
              }
            })
          ],
        ),
      ),
    );
  }
}