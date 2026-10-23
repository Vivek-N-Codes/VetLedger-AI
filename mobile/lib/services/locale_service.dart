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
    // Fallback to English, then to the key itself
    return dict?['en'] ?? key;
  }

  // Translate species dynamically
  static String translateSpecies(String? species) {
    if (species == null || species.isEmpty) return '';
    final s = species.toUpperCase();
    if (s.contains('CATTLE') || s.contains('COW')) {
      return currentLocale.value == 'mr' ? 'गाय / गोवंश' : (currentLocale.value == 'hi' ? 'गाय / गोवंश' : 'Cattle');
    } else if (s.contains('BUFFALO')) {
      return currentLocale.value == 'mr' ? 'म्हैस' : (currentLocale.value == 'hi' ? 'भैंस' : 'Buffalo');
    } else if (s.contains('GOAT')) {
      return currentLocale.value == 'mr' ? 'शेळी' : (currentLocale.value == 'hi' ? 'बकरी' : 'Goat');
    } else if (s.contains('SHEEP')) {
      return currentLocale.value == 'mr' ? 'मेंढी' : (currentLocale.value == 'hi' ? 'भेड़' : 'Sheep');
    } else if (s.contains('POULTRY')) {
      return currentLocale.value == 'mr' ? 'कुक्कुट' : (currentLocale.value == 'hi' ? 'मुर्गी' : 'Poultry');
    }
    return species;
  }

  // Translate sex dynamically
  static String translateSex(String? sex) {
    if (sex == null || sex.isEmpty) return '';
    final s = sex.toUpperCase();
    if (s == 'FEMALE' || s.startsWith('F')) {
      return currentLocale.value == 'mr' ? 'मादी' : (currentLocale.value == 'hi' ? 'मादा' : 'Female');
    } else if (s == 'MALE' || s.startsWith('M')) {
      return currentLocale.value == 'mr' ? 'नर' : (currentLocale.value == 'hi' ? 'नर' : 'Male');
    }
    return sex;
  }

  // Translate severity dynamically
  static String translateSeverity(String? severity) {
    if (severity == null || severity.isEmpty) return '';
    final s = severity.toUpperCase();
    switch (s) {
      case 'MILD':
        return currentLocale.value == 'mr' ? 'सौम्य' : (currentLocale.value == 'hi' ? 'हल्का / सौम्य' : 'Mild');
      case 'MODERATE':
        return currentLocale.value == 'mr' ? 'मध्यम' : (currentLocale.value == 'hi' ? 'मध्यम' : 'Moderate');
      case 'SEVERE':
        return currentLocale.value == 'mr' ? 'तीव्र / गंभीर' : (currentLocale.value == 'hi' ? 'गंभीर' : 'Severe');
      case 'CRITICAL':
        return currentLocale.value == 'mr' ? 'अति-गंभीर' : (currentLocale.value == 'hi' ? 'अति-गंभीर' : 'Critical');
      default:
        return severity;
    }
  }

  // Translate payment status
  static String translatePaymentStatus(String? status) {
    if (status == null || status.isEmpty) return '';
    final s = status.toUpperCase();
    switch (s) {
      case 'PAID':
        return currentLocale.value == 'mr' ? 'पूर्ण जमा' : (currentLocale.value == 'hi' ? 'भुगतान पूर्ण' : 'PAID');
      case 'PENDING':
        return currentLocale.value == 'mr' ? 'बाकी' : (currentLocale.value == 'hi' ? 'बकाया' : 'PENDING');
      case 'PARTIAL':
        return currentLocale.value == 'mr' ? 'अंशतः जमा' : (currentLocale.value == 'hi' ? 'आंशिक' : 'PARTIAL');
      default:
        return status;
    }
  }

  // Translate payment method
  static String translatePaymentMethod(String? method) {
    if (method == null || method.isEmpty) return '';
    final m = method.toUpperCase();
    switch (m) {
      case 'CASH':
        return currentLocale.value == 'mr' ? 'रोख (Cash)' : (currentLocale.value == 'hi' ? 'नकद (Cash)' : 'Cash');
      case 'UPI':
        return currentLocale.value == 'mr' ? 'यूपीआय (UPI)' : (currentLocale.value == 'hi' ? 'यूपीआई (UPI)' : 'UPI');
      case 'BANK_TRANSFER':
        return currentLocale.value == 'mr' ? 'बँक ट्रान्सफर' : (currentLocale.value == 'hi' ? 'बैंक ट्रांसफर' : 'Bank Transfer');
      case 'CHEQUE':
        return currentLocale.value == 'mr' ? 'धनादेश (Cheque)' : (currentLocale.value == 'hi' ? 'चेक (Cheque)' : 'Cheque');
      default:
        return method;
    }
  }

  // Translate clinical differential diagnosis & disease names
  static String translateDiagnosis(String? text) {
    if (text == null || text.isEmpty) return '';
    if (currentLocale.value == 'en') return text;

    final lower = text.toLowerCase();
    if (lower.contains('bovine respiratory') || lower.contains('brd') || lower.contains('pneumonia')) {
      return currentLocale.value == 'mr'
          ? 'बोव्हाइन श्वसन विकार संकुल (BRD / न्युमोनिया)'
          : 'बोवाइन श्वसन रोग कॉम्प्लेक्स (BRD / निमोनिया)';
    }
    if (lower.contains('foot and mouth') || lower.contains('fmd')) {
      return currentLocale.value == 'mr'
          ? 'लाळ-खुरकूत रोग (एफएमडी / तोंडखुरी-खुरखुरी)'
          : 'खुरपका-मुंहपका रोग (एफएमडी)';
    }
    if (lower.contains('haemorrhagic') || lower.contains('septic') || lower.contains('hs') || lower.contains('pasteurell')) {
      return currentLocale.value == 'mr'
          ? 'घटसर्प रोग (एच.एस. / हेमोरेजिक सेप्टीसीमिया)'
          : 'गलघोंटू रोग (एच.एस. / रक्तस्रावी सेप्टीसीमिया)';
    }
    if (lower.contains('blackquarter') || lower.contains('black quarter') || lower.contains('bq')) {
      return currentLocale.value == 'mr'
          ? 'फऱ्या / एकटांग्या रोग (ब्लॅकक्वार्टर)'
          : 'लंगड़ा बुखार / फऱ्या (ब्लैकक्वार्टर)';
    }
    if (lower.contains('mastitis')) {
      return currentLocale.value == 'mr'
          ? 'स्तनदाह / कासदाह (मॅस्टायटिस)'
          : 'थनैला रोग / स्तनदाह (मैस्टाइटिस)';
    }
    if (lower.contains('theileria') || lower.contains('theileriosis')) {
      return currentLocale.value == 'mr'
          ? 'थायलेरिओसिस (गोचीडजन्य आजार)'
          : 'थायलेरिया रोग (चीचड़ी जनित)';
    }
    if (lower.contains('babesia') || lower.contains('babesiosis') || lower.contains('redwater')) {
      return currentLocale.value == 'mr'
          ? 'बॅबेसियोसिस / लाल लघवी ताप (गोचीड ताप)'
          : 'बेबेसियोसिस / लाल पेशाब बुखार';
    }
    if (lower.contains('peste') || lower.contains('ppr') || lower.contains('goat plague')) {
      return currentLocale.value == 'mr'
          ? 'शेळ्या-मेंढ्यांमधील पीपीआर रोग (बकरी प्लेग)'
          : 'पीपीआर रोग (बकरी प्लेग)';
    }
    if (lower.contains('enterotoxaemia') || lower.contains('pulpy kidney')) {
      return currentLocale.value == 'mr'
          ? 'आंत्रविषार / पोटफुगी (एंटरोटॉक्सीमिया)'
          : 'आंत्रविषार (एंटरोटॉक्सीमिया)';
    }
    if (lower.contains('ketosis')) {
      return currentLocale.value == 'mr'
          ? 'केटॉसिस / चयापचय विकार'
          : 'कीटोसिस / चयापचय विकार';
    }
    if (lower.contains('milk fever') || lower.contains('hypocalc')) {
      return currentLocale.value == 'mr'
          ? 'दुग्धज्वर / कॅल्शियम कमतरता (मिल्क फीवर)'
          : 'दुग्ध ज्वर / कैल्शियम कमी (मिल्क फीवर)';
    }
    if (lower.contains('lumpy')) {
      return currentLocale.value == 'mr'
          ? 'लम्पी त्वचा रोग (LSD)'
          : 'लम्पी स्किन रोग (LSD)';
    }
    return text;
  }

  // Translate clinical advisories, biosecurity & insights
  static String translateAdvisory(String? text) {
    if (text == null || text.isEmpty) return '';
    if (currentLocale.value == 'en') return text;

    final lower = text.toLowerCase();
    if (lower.contains('isolate') || lower.contains('quarantine')) {
      return currentLocale.value == 'mr'
          ? 'आजारी जनावरांना तत्काळ निरोगी कळपापासून वेगळे (विलगीकरण) करा व हालचाल थांबवा.'
          : 'बीमार पशुओं को तुरंत स्वस्थ झुंड से अलग (आइसोलेट) करें और आवाजाही रोकें।';
    }
    if (lower.contains('disinfect') || lower.contains('bleach') || lower.contains('sodium')) {
      return currentLocale.value == 'mr'
          ? 'गोठा, गव्हाण आणि पाण्याच्या भांड्यांची २% सोडियम कार्बोनेट किंवा जंतुनाशकाने दररोज स्वच्छता करा.'
          : 'बाड़े, खोर और पानी के बर्तनों को 2% सोडियम कार्बोनेट या कीटाणुनाशक से साफ करें।';
    }
    if (lower.contains('visitor') || lower.contains('movement') || lower.contains('biosecurity')) {
      return currentLocale.value == 'mr'
          ? 'गोठ्यात बाहेरील व्यक्तींच्या प्रवेशावर नियंत्रण ठेवा; प्रवेशद्वारावर पोटॅशियम परमँगनेट पायधुणी वापरा.'
          : 'बाहरी व्यक्तियों का प्रवेश सीमित करें; प्रवेश द्वार पर फुटबाथ का प्रयोग करें।';
    }
    if (lower.contains('rehydration') || lower.contains('electrolyte') || lower.contains('drench')) {
      return currentLocale.value == 'mr'
          ? 'संतुलित इलेक्ट्रोलाइट्स द्रावण, मुबलक स्वच्छ पाणी आणि पचायला सोपा कोवळा हिरवा चारा द्या.'
          : 'संतुलित इलेक्ट्रोलाइट्स घोल, भरपूर साफ पानी और सुपाच्य हरा चारा उपलब्ध कराएं।';
    }
    if (lower.contains('bedding') || lower.contains('ventilat') || lower.contains('draft')) {
      return currentLocale.value == 'mr'
          ? 'थंड हवेच्या झोतापासून जनावरांचे रक्षण करा; गोठ्यातील गादी कोरडी, स्वच्छ आणि हवेशीर ठेवा.'
          : 'ठंडी हवा के झोंकों से बचाएं; फर्श को सूखा, साफ और हवादार रखें।';
    }
    if (lower.contains('twice daily') || lower.contains('monitor') || lower.contains('rectal')) {
      return currentLocale.value == 'mr'
          ? 'कळपातील इतर सर्व जनावरांचे दिवसातून दोनदा शारीरिक तापमान आणि भूक बारकाईने तपासा.'
          : 'झुंड के अन्य सभी पशुओं का दिन में दो बार तापमान और चारा खाना जांचें।';
    }
    return text;
  }

  // Translate standard symptoms dynamically
  static String translateSymptom(String? codeOrText) {
    if (codeOrText == null || codeOrText.isEmpty) return '';
    final s = codeOrText.toUpperCase();
    if (s.contains('FEVER') || s.contains('TEMPERATURE')) {
      return t('fever');
    }
    if (s.contains('COUGH') || s.contains('RESPIRATORY')) {
      return t('cough');
    }
    if (s.contains('APPETITE') || s.contains('OFF-FEED') || s.contains('FEED')) {
      return t('reduced_appetite');
    }
    if (s.contains('DIARRHEA') || s.contains('SCOUR') || s.contains('DYSENTERY')) {
      return t('diarrhea');
    }
    if (s.contains('LETHARGY') || s.contains('DULL') || s.contains('DEPRESSION')) {
      return t('lethargy');
    }
    if (s.contains('SALIVAT') || s.contains('DROOL')) {
      return t('excessive_salivation');
    }
    if (s.contains('MILK') || s.contains('PRODUCTION')) {
      return t('reduced_milk');
    }
    if (s.contains('NASAL') || s.contains('DISCHARGE')) {
      return t('nasal_discharge');
    }
    return codeOrText;
  }

  static const Map<String, Map<String, String>> _translations = {
    // -----------------------------------------------------------------
    // NAVIGATION & CORE
    // -----------------------------------------------------------------
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

    // -----------------------------------------------------------------
    // DASHBOARD METRICS & HEADERS
    // -----------------------------------------------------------------
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
    'surveillance_outbreaks': {
      'en': 'Disease Surveillance & Hotspots',
      'hi': 'रोग निगरानी एवं प्रकोप हॉटस्पॉट',
      'mr': 'रोग पाळत व संसर्ग हॉटस्पॉट',
    },
    'top_symptoms_trend': {
      'en': 'Top Presenting Symptoms',
      'hi': 'मुख्य प्राथमिक लक्षण',
      'mr': 'प्रमुख प्राथमिक लक्षणे',
    },
    'farms_overview': {
      'en': 'Farms & Village Coverage',
      'hi': 'फार्म और ग्राम कवरेज',
      'mr': 'गोठे व गावनिहाय आढावा',
    },
    'no_visits_yet': {
      'en': 'No clinical encounters recorded yet.',
      'hi': 'अभी कोई नैदानिक ​​विजिट दर्ज नहीं है।',
      'mr': 'अद्याप कोणतीही तपासणी नोंदवलेली नाही.',
    },

    // -----------------------------------------------------------------
    // COMMON ACTIONS & BUTTONS
    // -----------------------------------------------------------------
    'search': {
      'en': 'Search',
      'hi': 'खोजें',
      'mr': 'शोधा',
    },
    'search_animals_hint': {
      'en': 'Search by name, tag RFID, breed, or farm...',
      'hi': 'नाम, टैग RFID, नस्ल या फार्म से खोजें...',
      'mr': 'नाव, टॅग RFID, जात किंवा गोठ्यावरून शोधा...',
    },
    'search_farms_hint': {
      'en': 'Search farms by name, village, or owner...',
      'hi': 'फार्म, गांव या मालिक के नाम से खोजें...',
      'mr': 'गोठा, गाव किंवा मालकाच्या नावाने शोधा...',
    },
    'filter': {
      'en': 'Filter',
      'hi': 'फ़िल्टर',
      'mr': 'फिल्टर',
    },
    'all_species': {
      'en': 'All Species',
      'hi': 'सभी प्रजातियां',
      'mr': 'सर्व प्रजाती',
    },
    'all_villages': {
      'en': 'All Villages',
      'hi': 'सभी गांव',
      'mr': 'सर्व गावे',
    },
    'refresh': {
      'en': 'Refresh',
      'hi': 'ताजा करें',
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
    'close': {
      'en': 'Close',
      'hi': 'बंद करें',
      'mr': 'बंद करा',
    },
    'submit': {
      'en': 'Submit',
      'hi': 'सबमिट करें',
      'mr': 'सबमिट करा',
    },
    'retry': {
      'en': 'Retry Connection',
      'hi': 'पुनः प्रयास करें',
      'mr': 'पुन्हा प्रयत्न करा',
    },
    'loading': {
      'en': 'Loading data...',
      'hi': 'डेटा लोड हो रहा है...',
      'mr': 'माहिती लोड होत आहे...',
    },
    'waking_server': {
      'en': 'Waking up cloud server (Render free tier, please wait ~20s)...',
      'hi': 'क्लाउड सर्वर शुरू हो रहा है (कृपया 20 सेकंड प्रतीक्षा करें)...',
      'mr': 'क्लाउड सर्व्हर सुरू होत आहे (कृपया २० सेकंद थांबा)...',
    },

    // -----------------------------------------------------------------
    // ANIMAL & FARM PROFILES
    // -----------------------------------------------------------------
    'animal_details': {
      'en': 'Animal Profile & Medical Record',
      'hi': 'पशु प्रोफाइल एवं चिकित्सा रिकॉर्ड',
      'mr': 'जनावराचे प्रोफाइल व वैद्यकीय नोंद',
    },
    'animal_name': {
      'en': 'Animal Name',
      'hi': 'पशु का नाम',
      'mr': 'जनावराचे नाव',
    },
    'tag_rfid': {
      'en': 'Ear Tag / RFID Number',
      'hi': 'ईयर टैग / RFID नंबर',
      'mr': 'इअर टॅग / आर.एफ.आय.डी. क्रमांक',
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
    'age': {
      'en': 'Age',
      'hi': 'आयु',
      'mr': 'वय',
    },
    'age_years': {
      'en': 'Age (Years)',
      'hi': 'आयु (वर्ष)',
      'mr': 'वय (वर्षे)',
    },
    'sex': {
      'en': 'Sex',
      'hi': 'लिंग',
      'mr': 'लिंग',
    },
    'farm_name': {
      'en': 'Farm Name',
      'hi': 'फार्म का नाम',
      'mr': 'गोठ्याचे नाव',
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
    'address': {
      'en': 'Address / Landmark',
      'hi': 'पता / स्थान',
      'mr': 'पत्ता / ठिकाण',
    },
    'registered_on': {
      'en': 'Registered On',
      'hi': 'पंजीकरण दिनांक',
      'mr': 'नोंदणी तारीख',
    },
    'animals_on_farm': {
      'en': 'Animals on this Farm',
      'hi': 'इस फार्म के पशु',
      'mr': 'या गोठ्यातील जनावरे',
    },
    'new_encounter': {
      'en': 'Record Clinical Encounter',
      'hi': 'नई जांच दर्ज करें',
      'mr': 'नवीन तपासणी नोंदवा',
    },

    // -----------------------------------------------------------------
    // CLINICAL INTELLIGENCE & VISITS
    // -----------------------------------------------------------------
    'clinical_encounters': {
      'en': 'Clinical Encounters History',
      'hi': 'नैदानिक ​​विजिट इतिहास',
      'mr': 'तपासणी व उपचार इतिहास',
    },
    'presenting_complaint': {
      'en': 'Presenting Complaint',
      'hi': 'मुख्य शिकायत / लक्षण',
      'mr': 'तक्रार / प्राथमिक लक्षणे',
    },
    'clinical_observations': {
      'en': 'Physical Examination & Observations',
      'hi': 'शारीरिक परीक्षण एवं निरीक्षण',
      'mr': 'शारीरिक तपासणी व निरीक्षणे',
    },
    'rectal_temperature': {
      'en': 'Rectal Temperature (°C)',
      'hi': 'शरीर का तापमान (°C)',
      'mr': 'शरीराचे तापमान (°C)',
    },
    'severity': {
      'en': 'Severity Level',
      'hi': 'गंभीरता स्तर',
      'mr': 'गंभीरता पातळी',
    },
    'select_symptoms': {
      'en': 'Observed Symptoms',
      'hi': 'देखे गए लक्षण',
      'mr': 'दिसून आलेली लक्षणे',
    },
    'treatment_protocol': {
      'en': 'Treatment Given / Prescription',
      'hi': 'दिया गया उपचार एवं दवाइयां',
      'mr': 'दिलेले उपचार व औषधे',
    },
    'follow_up_notes': {
      'en': 'Follow-Up Instructions',
      'hi': 'फॉलो-अप एवं निर्देश',
      'mr': 'पुढील तपासणी व सूचना',
    },
    'consultation_fee': {
      'en': 'Consultation Fee (₹)',
      'hi': 'परामर्श शुल्क (₹)',
      'mr': 'तपासणी फी (₹)',
    },
    'service_fee': {
      'en': 'Procedure / Service Fee (₹)',
      'hi': 'सेवा शुल्क (₹)',
      'mr': 'सेवा / उपचार फी (₹)',
    },
    'medicine_fee': {
      'en': 'Medicine Cost (₹)',
      'hi': 'दवाइयों की लागत (₹)',
      'mr': 'औषध खर्च (₹)',
    },
    'total_charge': {
      'en': 'Total Visit Charge (₹)',
      'hi': 'कुल जांच शुल्क (₹)',
      'mr': 'एकूण तपासणी आकार (₹)',
    },
    'ai_differential_support': {
      'en': 'AI Clinical Differential Support',
      'hi': 'एआई क्लिनिकल निदान सहायता',
      'mr': 'एआय क्लिनिकल निदान व सल्ला',
    },
    'primary_diagnosis': {
      'en': 'Primary Differential Diagnosis',
      'hi': 'प्राथमिक संभावित निदान',
      'mr': 'प्राथमिक संभाव्य निदान',
    },
    'differential_diagnoses': {
      'en': 'Differential Diagnoses & Confidence',
      'hi': 'वैकल्पिक निदान एवं संभावना',
      'mr': 'पर्यायी संभाव्य निदान व शक्यता',
    },
    'diagnostic_tests': {
      'en': 'Recommended Diagnostic Tests',
      'hi': 'सुझाए गए प्रयोगशाला परीक्षण',
      'mr': 'शिफारस केलेल्या चाचण्या',
    },
    'biosecurity_advisories': {
      'en': 'Biosecurity & Prevention Advisories',
      'hi': 'जैव सुरक्षा एवं रोकथाम सलाह',
      'mr': 'जैविक सुरक्षा व प्रतिबंधक उपाय',
    },
    'follow_up_guidance': {
      'en': 'Clinical Monitoring & Follow-Up',
      'hi': 'क्लिनिकल निगरानी एवं फॉलो-अप',
      'mr': 'क्लिनिकल देखरेख व पुढील काळजी',
    },

    // -----------------------------------------------------------------
    // FINANCIAL LEDGER & RECEIPTS
    // -----------------------------------------------------------------
    'owner_statement': {
      'en': 'Owner Statement of Account',
      'hi': 'पशुपालक खाता विवरण',
      'mr': 'पशुपालक हिशोब विवरण',
    },
    'total_billed': {
      'en': 'Total Billed',
      'hi': 'कुल बिलिंग',
      'mr': 'एकूण बिल',
    },
    'total_paid': {
      'en': 'Total Paid',
      'hi': 'कुल भुगतान',
      'mr': 'एकूण जमा',
    },
    'outstanding_due': {
      'en': 'Outstanding Due',
      'hi': 'कुल बकाया',
      'mr': 'एकूण बाकी',
    },
    'due_balance': {
      'en': 'Due Balance',
      'hi': 'देय शेष',
      'mr': 'बाकी रक्कम',
    },
    'fully_settled': {
      'en': 'Fully Settled',
      'hi': 'पूर्ण चुकता',
      'mr': 'पूर्ण भरणा',
    },
    'record_payment': {
      'en': 'Record Payment',
      'hi': 'भुगतान दर्ज करें',
      'mr': 'पेमेंट नोंदवा',
    },
    'payment_amount': {
      'en': 'Payment Amount (₹)',
      'hi': 'भुगतान राशि (₹)',
      'mr': 'जमा रक्कम (₹)',
    },
    'payment_method': {
      'en': 'Payment Method',
      'hi': 'भुगतान माध्यम',
      'mr': 'पेमेंट प्रकार',
    },
    'reference_notes': {
      'en': 'Reference / Notes',
      'hi': 'संदर्भ / विवरण',
      'mr': 'संदर्भ / टीप',
    },
    'payment_history': {
      'en': 'Payment History & Receipts',
      'hi': 'भुगतान इतिहास एवं रसीदें',
      'mr': 'पेमेंट इतिहास व पावत्या',
    },
    'view_receipt': {
      'en': 'Receipt',
      'hi': 'रसीद',
      'mr': 'पावती',
    },
    'official_receipt': {
      'en': 'Official Veterinary Receipt',
      'hi': 'आधिकारिक पशु चिकित्सा रसीद',
      'mr': 'अधिकृत पशुवैद्यकीय पावती',
    },
    'receipt_number': {
      'en': 'Receipt #',
      'hi': 'रसीद सं.',
      'mr': 'पावती क्र.',
    },
    'payment_date': {
      'en': 'Date of Payment',
      'hi': 'भुगतान तिथि',
      'mr': 'पेमेंट दिनांक',
    },
    'amount_received': {
      'en': 'Amount Received',
      'hi': 'प्राप्त राशि',
      'mr': 'मिळालेली रक्कम',
    },
    'balance_after': {
      'en': 'Balance After Payment',
      'hi': 'भुगतान पश्चात शेष',
      'mr': 'पेमेंटनंतर शिल्लक',
    },
    'fifo_allocation': {
      'en': 'Automatic FIFO Bill Allocations',
      'hi': 'स्वचालित बिल आवंटन',
      'mr': 'स्वयंचलित बिल वाटप',
    },

    // -----------------------------------------------------------------
    // SYMPTOMS
    // -----------------------------------------------------------------
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
