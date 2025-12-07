import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/image_button.dart';
import 'package:nds_gui_kit/widgets/text.dart';

class NDSFavoriteAppsView extends StatefulWidget {
  const NDSFavoriteAppsView({super.key});

  @override
  State<NDSFavoriteAppsView> createState() => _NDSFavoriteAppsViewState();
}

class _NDSFavoriteAppsViewState extends State<NDSFavoriteAppsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NDSImageButton(
              onTap: () {},
              child: Center(
                child: NDSText(
                  text: 'Nintendo DS',
                  color: Colors.black,
                  extraBold: true,
                  fontSize: 40,
                ),
              ),
            ),
            NDSImageButton(
              onTap: () {},
              child: Center(
                child: NDSText(
                  text: 'GameBoy Advance',
                  color: Colors.black,
                  extraBold: true,
                  fontSize: 40,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NDSImageButton(
              onTap: () {},
              child: Center(
                child: NDSText(
                  text: 'Nintendo Switch',
                  color: Colors.black,
                  extraBold: true,
                  fontSize: 40,
                ),
              ),
            ),
            NDSImageButton(
              onTap: () {},
              child: Center(
                child: NDSText(
                  text: 'GameBoy Color',
                  color: Colors.black,
                  extraBold: true,
                  fontSize: 40,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
