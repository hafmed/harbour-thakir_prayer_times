﻿//-----1-12-2018-------------------
import QtQuick 2.6
import Sailfish.Silica 1.0
import harbour.thakir_prayer_times.calculcpp 1.0

Page {
id: pageAthkar
//-----
property string textAthkar_text: ""
property int playAthkarsource
property int stateMediaAl_Athkar_player:calculcpp.hafplaybackStatus();
property int textAthkar_textID:0

function gettextathkar(textAthkar_textID){
    switch (textAthkar_textID) {
    case 0:
        textAthkar_text = "الله أكبر، الله أكبر، الله أكبر، سبحان الذي سخر لنا هذا وما كنا له مقرنين وإنا إلى ربنا لمنقلبون اللهم إنا نسألك في سفرنا هذا البر والتقوى، ومن العمل ما ترضى، اللهم هون علينا سفرنا هذا واطو عنا بعده، اللهم أنت الصاحب في السفر، والخليفة في الأهل، اللهم أنى أعوذ بك من وعثاء السفر، وكآبة المنظر وسوء المنقلب في المال والأهل، وإذا رجع قالهن وزاد فيهن آيبون، تائبون، عابدون، لربنا حامدون."
        break
    case 1:
        textAthkar_text = "عن جابِرٍ رضيَ اللَّه عنه قال : كانَ رسولُ اللَّه صَلّى اللهُ عَلَيْهِ وسَلَّم يُعَلِّمُنَا الاسْتِخَارَةَ في الأُمُور كُلِّهَا كالسُّورَةِ منَ القُرْآنِ ، يَقُولُ إِذا هَمَّ أَحَدُكُمْ بالأمر ، فَليَركعْ رَكعتَيْنِ مِنْ غَيْرِ الفرِيضَةِ ثم ليقُلْ : اللَّهُم إِني أَسْتَخِيرُكَ بعِلْمِكَ ، وأستقدِرُكَ بقُدْرِتك ، وأَسْأَلُكَ مِنْ فضْلِكَ العَظِيم ، فإِنَّكَ تَقْدِرُ ولا أَقْدِرُ ، وتعْلَمُ ولا أَعْلَمُ ، وَأَنتَ علاَّمُ الغُيُوبِ . اللَّهُمَّ إِنْ كنْتَ تعْلَمُ أَنَّ هذا الأمرَ خَيْرٌ لي في دِيني وَمَعَاشي وَعَاقِبَةِ أَمْرِي » أَوْ قالَ : « عَاجِلِ أَمْرِي وَآجِله ، فاقْدُرْهُ لي وَيَسِّرْهُ لي، ثمَّ بَارِكْ لي فِيهِ ، وَإِن كُنْتَ تعْلمُ أَنَّ هذَا الأَمْرَ شرٌّ لي في دِيني وَمَعاشي وَعَاقبةِ أَمَرِي » أَو قال : « عَاجِل أَمري وآجِلهِ ، فاصْرِفهُ عَني ، وَاصْرفني عَنهُ، وَاقدُرْ لي الخَيْرَ حَيْثُ كانَ ، ثُمَّ رَضِّني بِهِ » قال : ويسمِّي حاجته . رواه البخاري."
        break
    case 2:
        textAthkar_text = "عَنْ أَبي هُرَيْرَةَ رَضِيَ اللهُ عَنْهُ أَنَّ رَسُولَ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ قَالَ : « مَنْ جَلَسَ مَجْلِساً كَثُرَ فِيهِ لَغَطُهُ ، فَقَالَ قَبْلَ أَنْ يَقُومَ مِنْ مَجْلِسِهِ ذَلِكَ : سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ ، أَشْهَدُ أَنْ لا إِلهَ إِلَّا أَنْتَ أَسْتَغْفِرُكَ وَأَتْوبُ إِلَيْكَ ، إِلَّا غُفِرَ لَهُ مَا كَانَ في مَجْلِسِهِ ذَلِكَ »."
        break
    case 3:
        textAthkar_text = "حدثنا خالد بن مخلد حدثنا سليمان قال حدثني عمرو بن أبي عمرو قال سمعت أنس بن مالك قال كان النبي صلى الله عليه وسلم يقول اللهم إني أعوذ بك من الهم والحزن والعجز والكسل والجبن والبخل وضلع الدين وغلبة الرجال"
        break
    case 4:
        textAthkar_text = "اللهم باعد بيني وبين خطاياي كما باعدت بين المشرق والمغرب اللهم نقني من خطاياي كما ينقى الثوب الأبيض من الدنس اللهم اغسلني من خطاياي بالثلج والماء والبرد رواه البخاري."
        break
    case 5:
        textAthkar_text = "اللهم إني أسألك العافية في الدنيا والآخرة ، اللهم إني أسألك العفو والعافية في ديني ودنياي وأهلي ومالي ، اللهم استر عورتي وآمن روعاتي ؛ اللهم احفظني من بين يدي ومن خلفي وعن يميني وعن شمالي ومن فوقي ، وأعوذ بعظمتك أن أغتال من تحتي"
        break
    case 6:
        textAthkar_text = "دعاء عظيم ثابت عن النبي الكريم صلى الله عليه وسلم، كان يقوله صلى الله عليه وسلم في كل مرة يخرج فيها من بيته، روى أهل السنن الأربعة وغيرهم عن أم المؤمنين أم سلمة هند المخزومية زوج النبي صلى الله عليه وسلم ورضي الله عنها أنها قالت:ما خرج النبي صلى الله عليه وسلم من بيتي قط إلا رفع طرفه إلى السماء فقال: اللهم إني أعوذ بك أن أضل أو أضل أو أزل أو أزل أو أظلم أو أظلم أو أجهل أو يجهل عليَّ."
        break
    case 7:
        textAthkar_text = "اللهمَّ اجعلْ في قلبي نورًا وفي بصري نورًا وفي سمعي نورًا وعن يميني نورًا وعن يساري نورًا وفوقي نورًا وتحتي نورًا وأمامي نورًا وخلفي نورًا واجعلْ لي نورًا."
        break
    case 8:
        textAthkar_text = "عَنْ ثَوْبَانَ رَضِيَ اللَّهُ عَنْهُ قَال: قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ مَنْ قَالَ حِينَ يُمْسِي: رَضِيتُ بِاللَّهِ رَبا وَبِالْإِسْلَامِ دِينا وَبِمُحَمَّدٍ نَبِيّا كَانَ حَقّا عَلَى اللَّهِ أَنْ يُرْضِيَهُ." + "\n" + "رواه الترمذي وقال:حَدِيثٌ حَسَنٌ" + "\n" + "-------" + "\n" +
        //2/13
        "عَنْ عَبْدِ اللَّهِ بْنِ مَسْعُودٍ رَضِيَ اللَّهُ عَنْهُ  قَالَ:كَانَ نَبِيُّ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ إِذَا أَمْسَى قَالَ  أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذِهِ اللَّيْلَةِ وَخَيْرَ مَا بَعْدَهَا وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذِهِ اللَّيْلَةِ وَشَرِّ مَا بَعْدَهَا رَبِّ أَعُوذُ بِكَ مِنْ الْكَسَلِ وَسُوءِ الْكِبَرِ رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ" + "\n" + "رواه ٌمسلم" + "\n" + "-------" + "\n" +
        //3/13
        "اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ." + "\n" + "رواه الترمذي" + "\n" + "-------" + "\n" +
        //4/13
        "عَنْ أَبِي هُرَيْرَةَ  رَضِيَ اللَّهُ عَنْهُ  أَنَّ رَسُولَ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ قَالَ:مَنْ قَالَ: لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ فِي يَوْمٍ مِائَةَ مَرَّةٍ كَانَتْ لَهُ عَدْلَ عَشْرِ رِقَابٍ وَكُتِبَتْ لَهُ مِائَةُ حَسَنَةٍ وَمُحِيَتْ عَنْهُ مِائَةُ سَيِّئَةٍ." + "\n" + "صحيح مسلم" + "\n" + "-------" + "\n" +
        //5/13
        "قراءة آية الكرسي:مَنْ قَالَهَا حِينَ يُمْسِي أُجِيرَ مِنْ الْجِنِّ حَتَّى يُصْبِحَ و مَنْ قَالَهَا حِينَ يُصْبِحُ أُجِيرَ مِنْ الْجِنِّ حَتَّى يُمْسِيَ." + "\n" + "رواه الطبراني وقال الهيتمي رجاله ثقات" + "\n" + "-------" + "\n" +
        //6/13
        "عَنِ ابْنَ عُمَرَ  رَضِيَ اللَّهُ عَنْهُمَا  قَالَ:لَمْ يَكُنْ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ يَدَعُ هَؤُلَاءِ الدَّعَوَاتِ  حِينَ يُمْسِي وَحِينَ يُصْبِحُ: اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ  وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي اللَّهُمَّ اسْتُرْ  عَوْرَاتِي وَآمِنْ رَوْعَاتِي اللَّهُمَّ احْفَظْنِي  مِنْ بَيْنِ يَدَيَّ وَمِنْ خَلْفِي وَعَنْ يَمِينِي وَعَنْ شِمَالِي وَمِنْ فَوْقِي وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ  تَحْتِي." + "\n" + "رواه أحمد والنسائي وأبو داود وابن ماجه وقال الألباني : صحيح" + "\n" + "-------" + "\n" +
        //7/13
        "قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ مَا مِنْ عَبْدٍ يَقُولُ فِي صَبَاحِ كُلِّ يَوْمٍ وَمَسَاءِ  كُلِّ لَيْلَةٍ  بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ  الْعَلِيمُ ثَلَاثَ مَرَّاتٍ لَمْ يَضُرَّهُ شَيْءٌ." + "\n" + "الترمذي وابن ماجه وقال الألباني : صحيح" + "\n" + "-------" + "\n" +
        //8/13
        " عَنْ أَبِي هُرَيْرَةَ أَنَّهُ قَالَ جَاءَ رَجُلٌ إِلَى النَّبِيِّ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ فَقَالَ : يَا رَسُولَ اللَّهِ مَا لَقِيتُ مِنْ عَقْرَبٍ لَدَغَتْنِي الْبَارِحَةَ قَالَ :أَمَا لَوْ قُلْتَ حِينَ أَمْسَيْتَ أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ - لَمْ تَضُرَّكَ  " + "\n" + "رواه ٌمسلم" + "\n" + "-------" + "\n"
        break
    case 9:
        textAthkar_text = "عَنْ ثَوْبَانَ رَضِيَ اللَّهُ عَنْهُ قَال: قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ مَنْ قَالَ حِينَ يُمْسِي: رَضِيتُ بِاللَّهِ رَبا وَبِالْإِسْلَامِ دِينا وَبِمُحَمَّدٍ نَبِيّا كَانَ حَقّا عَلَى اللَّهِ أَنْ يُرْضِيَهُ." + "\n" + "رواه الترمذي وقال:حَدِيثٌ حَسَنٌ" + "\n" + "-------" + "\n" +
        //2/13
        "عَنْ عَبْدِ اللَّهِ بْنِ مَسْعُودٍ رَضِيَ اللَّهُ عَنْهُ  قَالَ:كَانَ نَبِيُّ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ إِذَا أَمْسَى قَالَ  أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذِهِ اللَّيْلَةِ وَخَيْرَ مَا بَعْدَهَا وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذِهِ اللَّيْلَةِ وَشَرِّ مَا بَعْدَهَا رَبِّ أَعُوذُ بِكَ مِنْ الْكَسَلِ وَسُوءِ الْكِبَرِ رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ" + "\n" + "رواه ٌمسلم" + "\n" + "-------" + "\n" +
        //3/13
        "اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ." + "\n" + "رواه الترمذي" + "\n" + "-------" + "\n" +
        //4/13
        "عَنْ أَبِي هُرَيْرَةَ  رَضِيَ اللَّهُ عَنْهُ  أَنَّ رَسُولَ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ قَالَ:مَنْ قَالَ: لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ فِي يَوْمٍ مِائَةَ مَرَّةٍ كَانَتْ لَهُ عَدْلَ عَشْرِ رِقَابٍ وَكُتِبَتْ لَهُ مِائَةُ حَسَنَةٍ وَمُحِيَتْ عَنْهُ مِائَةُ سَيِّئَةٍ." + "\n" + "صحيح مسلم" + "\n" + "-------" + "\n" +
        //5/13
        "قراءة آية الكرسي:مَنْ قَالَهَا حِينَ يُمْسِي أُجِيرَ مِنْ الْجِنِّ حَتَّى يُصْبِحَ و مَنْ قَالَهَا حِينَ يُصْبِحُ أُجِيرَ مِنْ الْجِنِّ حَتَّى يُمْسِيَ." + "\n" + "رواه الطبراني وقال الهيتمي رجاله ثقات" + "\n" + "-------" + "\n" +
        //6/13
        "عَنِ ابْنَ عُمَرَ  رَضِيَ اللَّهُ عَنْهُمَا  قَالَ:لَمْ يَكُنْ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ يَدَعُ هَؤُلَاءِ الدَّعَوَاتِ  حِينَ يُمْسِي وَحِينَ يُصْبِحُ: اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ  وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي اللَّهُمَّ اسْتُرْ  عَوْرَاتِي وَآمِنْ رَوْعَاتِي اللَّهُمَّ احْفَظْنِي  مِنْ بَيْنِ يَدَيَّ وَمِنْ خَلْفِي وَعَنْ يَمِينِي وَعَنْ شِمَالِي وَمِنْ فَوْقِي وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ  تَحْتِي." + "\n" + "رواه أحمد والنسائي وأبو داود وابن ماجه وقال الألباني : صحيح" + "\n" + "-------" + "\n" +
        //7/13
        "قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ مَا مِنْ عَبْدٍ يَقُولُ فِي صَبَاحِ كُلِّ يَوْمٍ وَمَسَاءِ  كُلِّ لَيْلَةٍ  بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ  الْعَلِيمُ ثَلَاثَ مَرَّاتٍ لَمْ يَضُرَّهُ شَيْءٌ." + "\n" + "الترمذي وابن ماجه وقال الألباني : صحيح" + "\n" + "-------" + "\n" +
        //8/13
        " عَنْ أَبِي هُرَيْرَةَ أَنَّهُ قَالَ جَاءَ رَجُلٌ إِلَى النَّبِيِّ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ فَقَالَ : يَا رَسُولَ اللَّهِ مَا لَقِيتُ مِنْ عَقْرَبٍ لَدَغَتْنِي الْبَارِحَةَ قَالَ :أَمَا لَوْ قُلْتَ حِينَ أَمْسَيْتَ أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ - لَمْ تَضُرَّكَ  " + "\n" + "رواه ٌمسلم" + "\n" + "-------" + "\n"
        break
        }
}
Connections {
    target: calculcpp
    onSendToQmlDurationMedia :{
        ////console.log("from C++--durat: " + durat/1000)
        progressBar_positionMedia.maximumValue=durat/1000
    }
    onPositionChanged :{
        ////console.log("from C++--iPosition: " + iPosition/1000)
        progressBar_positionMedia.value=iPosition/1000
    }
}
SilicaFlickable {
    anchors.fill: parent
    contentHeight: column.height
    Column {
    id: column
    width: displayInfo_dpiWidth
    PageHeader {
       title: qsTr("Listening to some Athkar: ")
    }
    Row {
    id: iconButtons
    spacing: Theme.paddingLarge
    anchors.horizontalCenter: parent.horizontalCenter
    IconButton {
        id: play
        icon.source: "image://theme/icon-l-play"
        onClicked: {
            stateMediaAl_Athkar_player=calculcpp.hafplaybackStatus()
            if(stateMediaAl_Athkar_player===2){
                calculcpp.justeplay()
            }else{
                calculcpp.playathkar()
            }

            stateMediaAl_Athkar_player=calculcpp.hafplaybackStatus()
        }
        enabled: (stateMediaAl_Athkar_player===0 || stateMediaAl_Athkar_player===2 || progressBar_positionMedia.maximumValue ===progressBar_positionMedia.value)
    }
    IconButton {
        id: pause
        icon.source: "image://theme/icon-l-pause"
        onClicked: {
            calculcpp.pauseAthkar()
            stateMediaAl_Athkar_player=calculcpp.hafplaybackStatus()
        }
        enabled: stateMediaAl_Athkar_player===1 && progressBar_positionMedia.maximumValue !==progressBar_positionMedia.value
    }
    IconButton {
        id: stop
        icon.source: "image://theme/icon-l-clear"
        onClicked: {
            calculcpp.stopAthkar()
            stateMediaAl_Athkar_player=calculcpp.hafplaybackStatus()
        }
        enabled: (stateMediaAl_Athkar_player===1 || stateMediaAl_Athkar_player===2) && progressBar_positionMedia.maximumValue !==progressBar_positionMedia.value
    }
}
ProgressBar {
    id: progressBar_positionMedia
    width: parent.width
    minimumValue : 0
}
    ComboBox {
    id: athkar
    width: parent.width
    label: qsTr("Athkar: ")
    description : qsTr("Click to select a dhikr")
    currentIndex: settings.getValueFor("playAthkarsource","")
    menu: ContextMenu {
        MenuItem { text: qsTr("Doaa for Travel") }
        MenuItem { text: qsTr("Doaa Istikhara") }
        MenuItem { text: qsTr("Doaa Istighfar") }
        MenuItem { text: qsTr("Doaa Istiaatha") }
        MenuItem { text: qsTr("Doaa Istiftah") }
        MenuItem { text: qsTr("Doaa Affiya") }
        MenuItem { text: qsTr("Doaa leave the house") }
        MenuItem { text: qsTr("Doaa go to the mosque") }
        MenuItem { text: qsTr("Morning Athkar")}
        MenuItem { text: qsTr("Evening Athkar") }
    }
    onCurrentIndexChanged: {
    calculcpp.stopAthkar();
    stateMediaAl_Athkar_player=calculcpp.hafplaybackStatus()
    playAthkarsource=currentIndex
    settings.saveValueFor("playAthkarsource",playAthkarsource)
    gettextathkar(currentIndex);
      }
    }
    TextArea {
        color: "orange"
        font.family: "cursive"
        width: parent.width
        horizontalAlignment: Text.AlignJustify
        text: textAthkar_text
        wrapMode: Text.Wrap
        readOnly : true
        autoScrollEnabled : true
    }
   }
  }
    onStatusChanged: {
        if (status !== PageStatus.Active) {
            //-----
        }
    }
    Component.onCompleted: {
        textAthkar_textID=settings.getValueFor("playAthkarsource","0")
        gettextathkar(textAthkar_textID);
    }
}





