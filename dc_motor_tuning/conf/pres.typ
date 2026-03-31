#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#import "@preview/gentle-clues:1.3.1": *

#import "@preview/diatypst:0.8.0": *
#show: slides.with(
  // title: "МЕТОД НАСТРОЙКИ РЕГУЛЯТОРОВ С ПОМОЩЬЮ МЫСЛЕННОГО ЭКСПЕРИМЕНТА", // Required
  title: "Метод",
  subtitle: "настройки регуляторов с помощью мысленного эксперимента",
  date: "",
  authors: "Ярмолинский Арсений,\nпедагог дополнительного образования",
  // layout: "large"
  count: "number",
  toc: false,
)

#set heading(numbering: none)

#import "@preview/meander:0.3.1"

= Управление положением

== Мысленный эксперимент: управляем роботом с пульта

#v(2em)

Задача: повернуться на угол

#columns(2)[
  *Медленный робот*
  // #box(width: 100%, height: 70%, stroke: blue)
  #image("/typst/assets/image-7.png", height: 70%)

  #colbreak()
  *Быстрый робот*
  // #box(width: 100%, height: 70%, stroke: blue)
  #image("/typst/assets/image-6.png")
]

== Настраиваем П-регулятор

+ Представляем ситуацию, требующую коррекции
+ Оцениваем численное значение ошибки

#image("wall.excalidraw.png", height: 60%)

== Настраиваем П-регулятор (продолжение)

#enum(
  start: 3,
  [
    Представляем какое управляющее воздействие мы бы дали если бы управляли вручную],
  [Считаем коэффициент пропорциональности],
)

#image("wall2.excalidraw.png", height: 60%)

При необходимости оцениваем максимальное управляющее воздействие $u_max$, которые мы хотим позволить роботу отрабатывать

== Итоговый код регулятора

#text(size: 10pt)[
  #codly(
    annotations: (
      (
        start: 3,
        end: 4,
        content: [Весь код регулятора],
        // content: block(
        //   width: 2em,
        //   // Rotate the element to make it look nice
        //   // rotate(
        //   //   -90deg,
        //   //   align(center, box(width: 100pt)[Function body]),
        //   // ),
        // ),
      ),
    ),
    highlights: (
      (
        line: 2,
        start: 7,
        end: 8,
        fill: purple,
      ),
      (
        line: 2,
        start: 12,
        end: 15,
        fill: blue,
      ),
      (
        line: 2,
        start: 19,
        end: 22,
        fill: red,
      ),
      (
        line: 3,
        start: 7,
        end: 7,
        fill: blue,
      ),
      (
        line: 3,
        start: 11,
        end: 12,
        fill: purple,
      ),
      (
        line: 3,
        start: 16,
        end: 18,
        fill: red,
      ),
    ),
  )
  ```cpp
  float err = ...;
  float Kp = 80.0 / -5.0;
  float u = Kp * err;
  u = constrain(u, -umax, umax);
  drive(v - u, v + u);
  ```
]

*Настройка* - всего два параметра:
+ $K_p$ - Коэффициент пропорциональности (быстродействие и точность)
+ $u_max$ - Максимальное управляющее воздействие (скорость)

#memo(title: "Важно")[Всегда используйте *float* для математики!]

== Комбинирование регуляторов

// https://github.com/arsenier/ptaushka/blob/main/include/WallFollowing.h

#columns(2)[

  #set text(size: 8pt)

  #idea(title: "Идея")[Регуляторы по разным величинам можно комбинировать и усреднять для сложных поведений]

  Код - движение в лабиринте Micromouse: условное выравнивание по левой и правой стенке, безусловное выравнивание по углу

  #set text(size: 5.8pt)

  #let hl(line, fill) = (line: line, start: none, end: none, fill: fill)

  #codly(highlights: (
    hl(3, red),
    hl(6, red),
    hl(15, red),
    hl(4, green),
    hl(7, green),
    hl(20, green),
    hl(5, blue),
    hl(8, blue),
    hl(24, blue),
    hl(29, orange),
  ))
  ```cpp
  float wf_straight_tick(SensorData data)
  {
      float err_left = WF_LEFT_REFERENCE - data.dist_left;
      float err_right = WF_RIGHT_REFERENCE - data.dist_right;
      float err_angle = 0 - data.odom_theta;
      float theta_i0_left = err_left * wf_kp_left;
      float theta_i0_right = err_right * wf_kp_right;
      float theta_i0_angle = err_angle * wf_kp_angle;

      float theta_i0 = 0;
      size_t counter = 0;

      if (data.is_wall_left)
      {
          theta_i0 += theta_i0_left;
          counter++;
      }
      if (data.is_wall_right)
      {
          theta_i0 += theta_i0_right;
          counter++;
      }

      theta_i0 += theta_i0_angle;
      counter++;

      if (counter != 0)
      {
          theta_i0 /= counter;
      }

      return theta_i0;
  }
  ```
]

#heading(level: 2)[Задачи управления\ положением]

#v(1.2em)

#grid(
  columns: (1fr, 1fr),
  rows: (1fr, 2em, 1fr, 2em),
  gutter: 0em,
  align: center + horizon,

  image("/typst/assets/image.png"),

  image("/typst/assets/image-1.png"),

  [Следование по линии], [Движение вдоль стенки],

  grid.cell(colspan: 2)[
    #image("/typst/assets/image-2.png")
  ],
  grid.cell(colspan: 2)[
    Навигация в пространстве
  ],
)

== Только П-регулятор?

#let header-inset = 0.5em
#let content-inset = 0.5em

// #columns(2)[

#grid(
  columns: (1fr, 2fr),
  gutter: 1em,
  question(title: "Как так?", header-inset: header-inset, content-inset: content-inset)[#text(
    size: 10pt,
  )[Робот медленный и неточный]],

  // #colbreak()

  warning(
    title: "Причина",
    header-inset: header-inset,
    content-inset: content-inset,
  )[Высокая инерционность и нечуствительность на низких скоростях],
)
// ]

#align(center)[
  *Решение*
]

#columns(3)[

  #error(title: "Сделать полный ПИД", header-inset: header-inset, content-inset: content-inset, icon: none)[

    // Добавить в регулятор И и Д составляющие, чтобы получить ПИД.

    #text(size: 7pt)[
      #list(
        marker: "+",
        [Легко объясняется],
        [Есть готовые библиотеки],
        // [Один регулятор для всего],
      )
      #list(
        marker: "-",
        [Сложная настройка],
        [Невозможность достижения быстродействия и точности других методов],
      )
    ]
  ]
  // Плюсы:
  // Легко объясняется
  // Есть готовые библиотеки
  // Один регулятор для всего

  // Минусы:
  // Сложная настройка
  // Невозможность достижения быстродействия и точности метода с регуляторами скорости

  #colbreak()

  #success(
    title: text(size: 10pt)[Поставить более моментные моторы],
    header-inset: header-inset,
    content-inset: content-inset,
    icon: none,
  )[
    // Уменьшить инерционность робота, поставив более моментные моторы или добавив редуктор.

    #text(size: 8pt)[
      #list(marker: "+", [Простая настройка], [Высокое быстродействие и точность])
      #list(marker: "-", [Требуется изменение механики], [Снижение максимальной скорости робота])
    ]
  ]

  // Плюсы:
  // Отсутствие необходимости дополнительной настройки
  // Высокое быстродействие и точность
  // Минусы:
  // Требуется изменение механики
  // Снижение максимальной скорости робота

  #colbreak()

  #success(
    title: text(size: 10pt)[Добавить регуляторы скорости на моторы],
    header-inset: header-inset,
    content-inset: content-inset,
    icon: none,
  )[
    // Уменьшить инерционность робота добавив регуляторы скорости на привода.

    #text(size: 8pt)[
      #list(marker: "+", [Конкретный алгоритм настройки], [Высокое быстродействие и точность])
      #list(
        marker: "-",
        // [Требуется более глубокое понимание],
        [Много мест, где можно ошибится при реализации],
      )
    ]
  ]
  // Плюсы:
  // Конкретный алгоритм настройки
  // Высокое быстродействие и точность
  // Минусы:
  // Требуется более глубокое понимание
  // Много мест, где можно ошибится при реализации
]


= Настройка регулятора скорости

= Интермедия

// #heading(level: 2)[Поворот на 90 градусов\ по гироскопу]

// #v(2em)

// // Задача: повернуться на угол 30 градусов

// #columns(2)[
//   *Робот с прямым управлением моторами*

//   #box(width: 100%, height: 70%, stroke: blue)

//   #colbreak()
//   *Робот с регуляторами скорости на каждом моторе*

//   #box(width: 100%, height: 70%, stroke: blue)
// ]

// == Эффекты регулятора скорости

// #columns(2)[
//   *Колесо без регулятора*

//   #box(width: 100%, height: 70%, stroke: blue)

//   #colbreak()
//   *Колесо с регулятором скорости*

//   #box(width: 100%, height: 70%, stroke: blue)
// ]

#heading(level: 2)[Вычисление скорости вращения\ мотора]

#v(2em)

Два способа:

#columns(2)[
  - Период между тиками энкодера

  #v(1.5em)

  #error(title: [Не подходит])[Сильно теряет точность и быстродействие при низких и нулевых скоростях]

  #colbreak()

  - Путь за итерацию делить на время итерации

  #success(title: [Подходит])[Скорость должна быть со знаком

    Шумно, но можно фильтровать]
]

```cpp
vel = (angle - angle_old) / delta_time;
```

#heading(level: 2)[Измерение коэффициента\ усиления мотора $K_m$]

#v(2em)

+ Даем фиксированное управляющее воздействие
+ Измеряем получившуюся скорость
+ Считаем коэффициент усиления

#v(2em)

#image("../test_motor_simplified.excalidraw.png")

#heading(level: 2)[Оценка быстроты системы\
  (_постоянной времени_) $T_m$]

#v(1.5em)

#grid(
  columns: (1fr, 1fr),
  rows: (1fr, 2em, 1fr, 3em),
  align: center + horizon,
  image("n20.png"), image("introsat.png"),
  [$T=0.05-0.15s$], [$T=3-10s$],
  image("r25.png"), image("train.png"),
  [$T=0.1-0.3s$], [$T=60-180s$],
)

== Используем ПИ регулятор

#question(title: [Во сколько раз хотим ускорить систему?])[Это будет наш параметр Boost: $B$]

Коэффициенты считаются так:

$ K_p = B / K_m $
$ K_i = K_p / T_m $

== Пишем регулятор

// https://github.com/arsenier/nedoROS/blob/main/arduino_firmware/firmware/motor.ino

#text(size: 7pt)[
  #columns(2)[

    #let hl(line, fill) = (line: line, start: none, end: none, fill: fill)

    #codly(
      highlights: (
        hl(1, navy),
        hl(2, yellow),
        hl(3, navy),
        hl(4, red),
        hl(5, blue),
        hl(16, blue),
        // hl(20, blue),
        hl(19, blue),
        hl(22, blue),
        hl(24, blue),
        hl(27, blue),
        hl(17, red),
        // hl(21, red),
        hl(20, red),
        hl(23, red),
        hl(25, red),
        hl(28, red),
        hl(30, orange),
      ),
    )
    ```cpp
    float kMl = 4.5 / 150, kMr = 4.4 / 150;
    float Boost = 4;
    float tm = 250.0 / 1000;
    float kp_speedR = Boost / kMr, ki_speedR = Boost / (tm * kMr);
    float kp_speedL = Boost / kMl, ki_speedL = Boost / (tm * kMl);

    void motorRPM(float rpmL, float rpmR, uint32_t iter_time_ms = 5 /*[ms]*/)
    {
      static uint32_t timer = 0;
      while (millis() - timer < iter_time_ms)
        ;
      timer = millis();

      vel_est_tick();

      float errL = rpmL - getvel_left();
      float errR = rpmR - getvel_right();

      static float uIL = 0;
      static float uIR = 0;

      uIL += errL * ki_speedL * iter_time_ms / 1000.0;
      uIR += errR * ki_speedR * iter_time_ms / 1000.0;
      uIL = constrain(uIL, -255, 255);
      uIR = constrain(uIR, -255, 255);

      float uL = errL * kp_speedL + uIL;
      float uR = errR * kp_speedR + uIR;

      drive(uL, uR);
    }
    ```

  ]
]

== Используем регулятор

#text(size: 18pt)[
  ```cpp
  void loop()
  {
    motorRPM(vel_left, vel_right);
  }
  ```
]

== Спасибо за внимание


#align(center + horizon)[
  #grid(
    columns: (1fr, 1fr),

    //   #image("/typst/assets/image-3.png")
    image("/typst/assets/image-5.png"),

    box(
      image("/typst/assets/photo.jpg", height: 60%),
      clip: true,
      radius: 2.5cm,
    ),
    [],

    [],

    //   #colbreak()

    //   Мой блог:\
    //   https://arsenier.github.io/
    //   #image("/typst/assets/image-4.png")
  )
]
