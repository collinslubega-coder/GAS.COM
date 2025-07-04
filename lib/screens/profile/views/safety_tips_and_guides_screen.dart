import 'package:flutter/material.dart';
// Consistent absolute import for constants.dart
import 'package:gas_com/constants.dart';

// NEW ATTEMPT: Using an absolute package import for tips.dart as a workaround.
// This path directly points from your project's lib folder.
import 'package:gas_com/screens/profile/views/components/tips.dart'; // Changed import path for tips.dart

class SafetyTipsAndGuidesScreen extends StatelessWidget {
  const SafetyTipsAndGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety Tips & Guides"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(defaultPadding),

        // 'const' keyword removed here to resolve 'non_constant_list_element' error.
        children: [
          Tip(
            title: "Setting Up Your Cylinder",
            tips: const [
              "Ensure the cylinder is upright on a firm, level surface.",
              "Check that the regulator switch is in the 'OFF' position before connecting.",
              "Attach the regulator to the cylinder valve and turn the knob clockwise until tight. Do not overtighten.",
              "Connect the hosepipe securely to both the regulator and the appliance.",
            ],
          ),
          Tip(
            title: "Proper Gas Usage",
            tips: const [
              "Always light the match or lighter BEFORE turning on the gas tap on your cooker.",
              "Never leave cooking unattended.",
              "Turn off the regulator switch when the cylinder is not in use, especially at night and when leaving the house.",
              "Keep the cylinder away from direct heat, sunlight, and other flammable materials.",
            ],
          ),
          Tip(
            title: "Key Safety Measures",
            tips: const [
              "Ensure your kitchen is well-ventilated to allow any potential leaks to disperse.",
              "Regularly check the hosepipe for cracks or damage. We recommend replacing it every 2 years.",
              "To check for leaks, apply soapy water to the joints. If you see bubbles, there is a leak. Turn off the regulator immediately and contact us.",
              "Never use a mobile phone near a suspected gas leak.",
            ],
          ),
          Tip(
            title: "Troubleshooting Common Issues",
            tips: const [
              "If you smell gas: Do NOT switch on/off any electrical switches. Extinguish all naked flames. Turn off the regulator, open all windows and doors, and call for help.",
              "If the burner doesn't light: Check if the cylinder is empty. Ensure the regulator is on and the cooker tap is working. Check for blockages in the burner holes.",
            ],
          ),
        ],
      ),
    );
  }
}