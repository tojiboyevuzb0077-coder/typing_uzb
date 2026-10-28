import '../models/lesson_model.dart';

class LessonsData {
  static const List<Lesson> allLessons = [
    // Home Row
    Lesson(
      id: 'l1',
      number: 1,
      title: 'Keys: F and J',
      category: LessonCategory.homeRow,
      content: 'fff jjj fff jjj fj fj jf jf fjff jfjj ffff jjjj',
    ),
    Lesson(
      id: 'l2',
      number: 2,
      title: 'Keys: D and K',
      category: LessonCategory.homeRow,
      content: 'ddk kkd d d k k dk kd fk dk jl sk dl fj dk kd',
    ),
    Lesson(
      id: 'l3',
      number: 3,
      title: 'Keys: S and L',
      category: LessonCategory.homeRow,
      content: 'sl sl ls ls asdf jkl; asdf jkl; sad lad fall dall',
    ),
    Lesson(
      id: 'l4',
      number: 4,
      title: 'Keys: A and ; (Semicolon)',
      category: LessonCategory.homeRow,
      content: 'a; a; aaaa ;;;; asdf jkl; alas flak sala glad dad',
    ),
    Lesson(
      id: 'l5',
      number: 5,
      title: 'Home Row Practice',
      category: LessonCategory.homeRow,
      content: 'asdf jkl; sad lad fall salad glad glass flask all',
    ),

    // Top Row
    Lesson(
      id: 'l6',
      number: 6,
      title: 'Keys: E and I',
      category: LessonCategory.topRow,
      content: 'ded kik ded kik side idle lead idea deed file slide',
    ),
    Lesson(
      id: 'l7',
      number: 7,
      title: 'Keys: R and U',
      category: LessonCategory.topRow,
      content: 'frf juj frf juj rule rude ride sure pure ruler dark',
    ),
    Lesson(
      id: 'l8',
      number: 8,
      title: 'Keys: T and Y',
      category: LessonCategory.topRow,
      content: 'ftf jyj ftf jyj try type tasty tall yard stay party',
    ),
    Lesson(
      id: 'l9',
      number: 9,
      title: 'Keys: O and P',
      category: LessonCategory.topRow,
      content: 'lol ;p; lol ;p; pool polar loop drop stop open pop',
    ),
    Lesson(
      id: 'l10',
      number: 10,
      title: 'Keys: Q and W',
      category: LessonCategory.topRow,
      content: 'aqa sws aqa sws quick quiet water queen power tower',
    ),

    // Bottom Row
    Lesson(
      id: 'l11',
      number: 11,
      title: 'Keys: V and M',
      category: LessonCategory.bottomRow,
      content: 'fvf jmj fvf jmj move make vim cave wave moss same',
    ),
    Lesson(
      id: 'l12',
      number: 12,
      title: 'Keys: C and , (Comma)',
      category: LessonCategory.bottomRow,
      content: 'dcd k,k dcd k,k ice, can, call, car, code, core,',
    ),
    Lesson(
      id: 'l13',
      number: 13,
      title: 'Keys: X and . (Period)',
      category: LessonCategory.bottomRow,
      content: 'sxs l.l sxs l.l box. six. text. flex. next. exit.',
    ),
    Lesson(
      id: 'l14',
      number: 14,
      title: 'Keys: Z and /',
      category: LessonCategory.bottomRow,
      content: 'aza ;/; aza ;/; zero zeal jazz quiz lazy haze/path',
    ),
    Lesson(
      id: 'l15',
      number: 15,
      title: 'Bottom Row Practice',
      category: LessonCategory.bottomRow,
      content: 'zxcv bnm, . / zoom valve crazy music pizza oxygen',
    ),

    // Numbers
    Lesson(
      id: 'l16',
      number: 16,
      title: 'Numbers: 1, 2, 3, 4, 5',
      category: LessonCategory.numbers,
      content: '11 22 33 44 55 12345 54321 1a 2s 3d 4f 5g 25143',
    ),
    Lesson(
      id: 'l17',
      number: 17,
      title: 'Numbers: 6, 7, 8, 9, 0',
      category: LessonCategory.numbers,
      content: '66 77 88 99 00 67890 09876 6h 7j 8k 9l 0; 89067',
    ),

    // Words
    Lesson(
      id: 'l18',
      number: 18,
      title: 'Common Typing Words',
      category: LessonCategory.words,
      content: 'the and for that with have this from they will would',
    ),

    // Sentences
    Lesson(
      id: 'l19',
      number: 19,
      title: 'English Sentences',
      category: LessonCategory.sentences,
      content: 'The quick brown fox jumps over the lazy dog easily.',
    ),
    Lesson(
      id: 'l20',
      number: 20,
      title: 'Uzbek Latin Sentences (O\'zbekcha)',
      category: LessonCategory.sentences,
      content: 'Salom dunyo! O\'zbekiston bo\'ylab tezkor va chiroyli yozishni o\'rganamiz.',
    ),
  ];
}
