# Mou(jeek's)Hack

## Сборка проекта
1. Установите **[moonly-cli](https://github.com/themusaigen/moonly-command-tool)**
2. Соберите проект командой `moonly.exe bundle`

## Модули
Любой пользователь может дополнять функционал скрипта с помощью модулей, функционал API представлен ниже, больше примеров в `\example-modules`
### Установка модулей
Перенесите сторонний модуль в папку `moonloader\MouHack\modules` или установите публичный модуль в меню скрипта (Настройки -> Модули)

### Разработка модулей
#### Структура
Модуль - папка, внутри которой находятся скрипты и `module.json` - файл, содержащий информацию о вашем модуле.
**Публичный модуль** - модуль, находящийся внутри этого репозитория в директории `\modules`
#### module.json
```json
{
    "name": "module-name", // название модуля, не должно содержать пробелов или кириллицы
    "author": "your-nickname", // ваш никнейм
    "description": "Test module for MouHack", // описание модуля
    "version": "0.0.1" // текущая версия модуля. Необходима для системы обновления публичных модулей.
}
```
### Публикация модулей
1. Создайте коммит и добавьте (папку или SubModule) с вашим модулем в `\modules`
2. Создайте PullRequest

## API
**Category**
| Метод / Поле | Описание |
|---|---|
|`category.uid` | `number`, Индекс категории в `Categories.list` |
|`category.strId` | `string`, Уникальный строковой ID |
|`category.name` | `string`, Название категории |
|`category.pages` | `Page[]`, Список страниц в категории |
|`category.pagesLabels` | `string[]`, Список названий страниц в категории |
|`Page page = category:AddPage(string strId, string name)`| Создает страницу в этой категории |

**Categories**
| Метод / Поле | Описание |
|---|---|
|`Categories.list` | `Category[]`, Список всех категорий |
|`Category category = Categories:new(string strId, string name)` | Создает категорию |
|`Category? category = Categories:Find(string strId, string name)` | Ищет категорию по ее `strId` или `name` |

**Page**

**FuncType**
| Тип | Описание |
|---|---|
| `FuncType.Toggle` | Переключатель (ToggleButton) |
| `FuncType.InputInt` | Поле ввода для чисел |
| `FuncType.SliderFloat` | Слайдер числа с плавающей запятой |
| `FuncType.Button` | Кнопка |
| `FuncType.Combo` | Комбо-бокс |
| `FuncType.Frame` | Кастомная функция для отрисовки |
| `FuncType.Color` | Выбор цвета |
| `FuncType.SliderInt` | Слайдер для числа |
| `FuncType.Input` | Поле воода |
| `FuncType.Checkbox` | Чекбокс |
| `FuncType.TextArea` | Большое поле ввода. Отображается как обычное, но при клике открывает Popup с большим полем ввода |
| `FuncType.Selector` | Селектор из нескольких значений |
| `FuncType.NoAction` | Без виджета, отображается только название |

**Func**
Поля функции зависят от ее типа, однако всегда содержат следующие:
| Поле | Описание |
|---|---|
| `func.uid` | `number`, уникальный ID функции |
| `func.type` | `FuncType`, тип функции |
| `func.width` | `number?`, ширина виджета |
| `func.height` | `number?`, высота виджета |
| `func.noIndexInSearch` | `boolean?`, отключить отображение функции в поиске |
| `func.notBindable` | `boolean?`, запретить устанавливать бинд на функцию |
| `func.options` | `Func[]`, параметры функции |
| `func.label` | `string`, название функции |
| `func.description` | `string?`, описание функции |
| `func.unsafe` | `(string\|boolean)?`, является ли функция безопасной для использования |
| `func.isOption` | `boolean?`, является ли функция параметром (системное поле) |
| `func.onChanged` | `function?`, коллбек, вызываемый при взаимодействием с виджетом функции |
| `func.onFrame` | `function?`, коллбек, вызываемый после отрисовки виджета функции |
| `func.parentPage` | `Page?`, родительская страница (равно `nil` если `isOption == true`) |

Поля для различных типов функций:
**Toggle**
| Поле | Описание |
|---|---|
| `func.value` | `mimgui.bool` |

**InputInt**
| Поле | Описание |
|---|---|
| `func.flags` | `number?` |
| `func.width` | `number?` |
| `func.hint` | `string?` |
| `func.value` | `mimgui.char` |

**SliderFloat**
| Поле | Описание |
|---|---|
| `func.max` | `number` |
| `func.format` | `string?` |
| `func.value` | `mimgui.float` |
| `func.min` | `number` |
| `func.width` | `number?` |

**Button**
| Поле | Описание |
|---|---|
| `func.size` | `ImVec2?` |
| `func.text` | `string?` |

**Combo**
| Поле | Описание |
|---|---|
| `func.items` | `string[]` |
| `func.width` | `number?` |
| `func.value` | `mimgui.int` |

**Frame**

**Color**
| Поле | Описание |
|---|---|
| `func.flags` | `number?` |
| `func.value` | `mimgui.float[4]` |

**SliderInt**
| Поле | Описание |
|---|---|
| `func.max` | `number` |
| `func.format` | `string?` |
| `func.value` | `mimgui.float` |
| `func.min` | `number` |
| `func.width` | `number?` |

**Input**
| Поле | Описание |
|---|---|
| `func.flags` | `number?` |
| `func.width` | `number?` |
| `func.hint` | `string?` |
| `func.value` | `mimgui.char` |

**Checkbox**
| Поле | Описание |
|---|---|
| `func.value` | `mimgui.bool` |

**TextArea**
| Поле | Описание |
|---|---|
| `func.width` | `number?` |
| `func.hint` | `string?` |
| `func.value` | `mimgui.char` |

**Selector**
| Поле | Описание |
|---|---|
| `func.items` | `string[]` |
| `func.width` | `number?` |
| `func.value` | `mimgui.int` |

**NoAction**
| Поле | Описание |
|---|---|

**Text**
| Поле | Описание |
|---|---|
| `func.text` | `string` |