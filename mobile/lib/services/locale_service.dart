import 'package:flutter/material.dart';

class LocaleService {
  static final ValueNotifier<String> currentLocale = ValueNotifier<String>('en');

  static String get code => currentLocale.value;

  static void setLocale(String langCode) {
    if (['en', 'hi', 'mr'].contains(langCode)) {
      currentLocale.value = langCode;
    }
  }

  static String get languageName {
    switch (currentLocale.value) {
      case 'hi':
        return 'हिन्दी';
      case 'mr':
        return 'मराठी';
      default:
        return 'English';
    }
  }

  static String t(String key) {
    final lang = currentLocale.value;
    final dict = _translations[key];
    if (dict != null && dict.containsKey(lang)) {
      return dict[lang]!;
    }
    // Fallback to English
    return dict?['en'] ?? key;
  }

  static const Map<String, Map<String, String>> _translations = {
    // Navigation
    'app_title': {
      'en': 'VetLedger AI',
      'hi': 'वेटलेजर एआई',
      'mr': 'व्हेटलेजर एआय',
    },
    'app_subtitle': {
      'en': 'Clinical Intelligence & Surveillance',
      'hi': 'क्लिनिकल इंटेलिजेंस और रोग निगरानी',
      'mr': 'क्लिनिकल बुद्धिमत्ता आणि रोग पाळत',
    },
    'dashboard': {
      'en': 'Dashboard',
      'hi': 'डैशबोर्ड',
      'mr': 'डॅशबोर्ड',
    },
    'animals': {
      'en': 'Animals',
      'hi': 'पशु / मवेशी',
      'mr': 'जनावरे',
    },
    'farms': {
      'en': 'Farms',
      'hi': 'डेयरी फार्म',
      'mr': 'गोठे / फार्म्स',
    },
    'surveillance': {
      'en': 'Surveillance',
      'hi': 'रोग निगरानी',
      'mr': 'रोग पाळत',
    },
    'ledger': {
      'en': 'Ledger',
      'hi': 'खाता / लेजर',
      'mr': 'हिशोब / लेजर',
    },
    'quick_visit': {
      'en': 'Quick Clinical Visit',
      'hi': 'त्वरित पशु जांच / विजिट',
      'mr': 'त्वरित तपासणी / व्हिजिट',
    },
    'backend_settings': {
      'en': 'Backend API Settings',
      'hi': 'सर्वर एपीआई सेटिंग्स',
      'mr': 'सर्व्हर एपीआय सेटिंग्ज',
    },
    'change_language': {
      'en': 'Change Language',
      'hi': 'भाषा बदलें',
      'mr': 'भाषा बदला',
    },

    // Dashboard Cards
    'total_animals': {
      'en': 'Total Animals',
      'hi': 'कुल मवेशी',
      'mr': 'एकूण जनावरे',
    },
    'farms_tracked': {
      'en': 'Farms Tracked',
      'hi': 'पंजीकृत फार्म',
      'mr': 'नोंदणीकृत गोठे',
    },
    'villages_covered': {
      'en': 'Villages Covered',
      'hi': 'शामिल गांव',
      'mr': 'गावांची संख्या',
    },
    'active_alerts': {
      'en': 'Active Alerts',
      'hi': 'सक्रिय चेतावनी',
      'mr': 'सक्रिय अलर्ट्स',
    },
    'recent_clinical_visits': {
      'en': 'Recent Clinical Visits',
      'hi': 'हालिया जांच रिकॉर्ड',
      'mr': 'अलीकडील तपासणी नोंदी',
    },
    'view_all': {
      'en': 'View All',
      'hi': 'सभी देखें',
      'mr': 'सर्व पहा',
    },
    'register_new_animal': {
      'en': 'Register New Animal',
      'hi': 'नया पशु पंजीकृत करें',
      'mr': 'नवीन जनावराची नोंदणी',
    },
    'register_new_farm': {
      'en': 'Register New Farm',
      'hi': 'नया फार्म जोड़ें',
      'mr': 'नवीन गोठ्याची नोंदणी',
    },

    // Actions & Fields
    'search': {
      'en': 'Search',
      'hi': 'खोजें',
      'mr': 'शोधा',
    },
    'filter': {
      'en': 'Filter',
      'hi': 'फ़िल्टर',
      'mr': 'फिल्टर',
    },
    'refresh': {
      'en': 'Refresh',
      'hi': 'रिफ्रेश',
      'mr': 'ताजे करा',
    },
    'save': {
      'en': 'Save & Submit',
      'hi': 'सुरक्षित करें',
      'mr': 'जतन करा',
    },
    'cancel': {
      'en': 'Cancel',
      'hi': 'रद्द करें',
      'mr': 'रद्द करा',
    },
    'farmer_name': {
      'en': 'Farmer / Owner Name',
      'hi': 'पशुपालक / किसान का नाम',
      'mr': 'शेतकरी / मालकाचे नाव',
    },
    'contact_number': {
      'en': 'Contact Number',
      'hi': 'मोबाइल नंबर',
      'mr': 'संपर्क क्रमांक',
    },
    'village': {
      'en': 'Village',
      'hi': 'गांव',
      'mr': 'गाव',
    },
    'species': {
      'en': 'Species',
      'hi': 'प्रजाति',
      'mr': 'प्रजाती',
    },
    'breed': {
      'en': 'Breed',
      'hi': 'नस्ल',
      'mr': 'जात / ब्रीड',
    },
    'total_due': {
      'en': 'Total Due',
      'hi': 'कुल बकाया',
      'mr': 'एकूण बाकी',
    },
    'total_paid': {
      'en': 'Total Paid',
      'hi': 'कुल भुगतान',
      'mr': 'एकूण जमा',
    },
    'record_payment': {
      'en': 'Record Payment',
      'hi': 'भुगतान दर्ज करें',
      'mr': 'पेमेंट नोंदवा',
    },

    // Common Symptoms
    'fever': {
      'en': 'Fever / High Temperature',
      'hi': 'बुखार / तेज तापमान',
      'mr': 'ताप / जास्त तापमान',
    },
    'cough': {
      'en': 'Cough / Respiratory Issues',
      'hi': 'खांसी / सांस लेने में तकलीफ',
      'mr': 'खोकला / श्वास त्रास',
    },
    'reduced_appetite': {
      'en': 'Reduced Appetite / Off-feed',
      'hi': 'भूख में कमी / चारा न खाना',
      'mr': 'चारा न खाणे / भूक मंदावणे',
    },
    'diarrhea': {
      'en': 'Diarrhea / Loose Motion',
      'hi': 'दस्त / डायरिया',
      'mr': 'हगवण / जुलाब',
    },
    'lethargy': {
      'en': 'Lethargy / Dull Demeanor',
      'hi': 'सुस्ती / कमजोरी',
      'mr': 'सुस्ती / थकवा',
    },
    'excessive_salivation': {
      'en': 'Excessive Salivation / Drooling',
      'hi': 'मुंह से लार टपकना',
      'mr': 'तोंडातून लाळ गळणे',
    },
    'reduced_milk': {
      'en': 'Reduced Milk Yield',
      'hi': 'दूध उत्पादन में कमी',
      'mr': 'दूध उत्पादनात घट',
    },
    'nasal_discharge': {
      'en': 'Nasal Discharge',
      'hi': 'नाक से स्राव / पानी बहना',
      'mr': 'नाकातून पाणी / शेबूड गळणे',
    },
  };
}
