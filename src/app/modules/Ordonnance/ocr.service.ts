// ocr.service.ts
import { Injectable } from '@nestjs/common';
import * as Tesseract from 'tesseract.js';

@Injectable()
export class OcrService {
  async recognizeMedicationNames(imagePath: string): Promise<string[]> {
    try {
      const result = await Tesseract.recognize(
        imagePath,
        'eng', // or appropriate language
        {
          logger: m => console.log(m)
        }
      );

      // Process the text to extract medication names
      return this.extractMedicationNames(result.data.text);
    } catch (error) {
      throw new Error(`OCR processing failed: ${error.message}`);
    }
  }

  private extractMedicationNames(text: string): string[] {
    // Complete list of 78 medication names from your dataset
    const medicationNames = [
      'Beklo', 'Maxima', 'Leptic', 'Esoral', 'Omastin', 'Esonix', 'Canazole',
      'Fixal', 'Progut', 'Diflu', 'Montair', 'Flexilax', 'Maxpro', 'Vifas',
      'Conaz', 'Fexofast', 'Fenadin', 'Telfast', 'Dinafex', 'Ritch', 'Renova',
      'Flugal', 'Axodin', 'Sergel', 'Nexum', 'Opton', 'Nexcap', 'Fexo', 'Montex',
      'Exium', 'Lumona', 'Napa', 'Azithrocin', 'Atrizin', 'Monas', 'Nidazyl',
      'Metsina', 'Baclon', 'Rozith', 'Bicozin', 'Ace', 'Amodis', 'Alatrol',
      'Napa Extend', 'Rivotril', 'Montene', 'Filmet', 'Aceta', 'Tamen', 'Bacmax',
      'Disopan', 'Rhinil', 'Flamyd', 'Metro', 'Zithrin', 'Candinil', 'Lucan-R',
      'Backtone', 'Bacaid', 'Eitzin', 'Az', 'Romycin', 'Azyth', 'Cetisoft',
      'Dancel', 'Tridosil', 'Nizoder', 'Ketoral', 'Ketocon', 'Ketotab', 'Ketozol',
      'Denixil', 'Provair', 'Odmon', 'Baclofen', 'MKast', 'Trilock', 'Flexibac'
    ];

    // Pre-process the text
    const cleanedText = text.toLowerCase()
      .replace(/[^a-z0-9\s]/g, ' ') // Remove special chars
      .replace(/\s+/g, ' ')         // Normalize whitespace
      .trim();

    // Find matches using more sophisticated matching
    const foundMeds = medicationNames.filter(med => {
      const medLower = med.toLowerCase();

      // Exact match
      if (cleanedText.includes(medLower)) {
        return true;
      }

      // Partial match (handles common misspellings or OCR errors)
      const medParts = medLower.split(/\s+/);
      if (medParts.every(part => cleanedText.includes(part))) {
        return true;
      }

      // Handle common OCR confusions (like '1' vs 'l', '0' vs 'o')
      const ocrVariations = this.getOcrVariations(medLower);
      return ocrVariations.some(variation => cleanedText.includes(variation));
    });

    // Remove duplicates and return
    return [...new Set(foundMeds)];
  }

  private getOcrVariations(medName: string): string[] {
    // Common OCR misreadings
    const ocrConfusions: Record<string, string[]> = {
      'o': ['0', 'a'],
      'l': ['1', 'i'],
      'z': ['2'],
      'e': ['c'],
      'a': ['@'],
      's': ['5', '$'],
      // Add more as needed based on your OCR results
    };

    const variations = [medName];

    // Generate variations by replacing commonly confused characters
    for (const [correct, replacements] of Object.entries(ocrConfusions)) {
      for (const replacement of replacements) {
        variations.push(medName.replace(new RegExp(correct, 'g'), replacement));
      }
    }

    return variations;
  }}