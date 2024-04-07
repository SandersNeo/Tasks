﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает сообщение на основании предмета по шаблону сообщения.
//
// Параметры:
//  Шаблон                   - СправочникСсылка.ШаблоныСообщений - ссылка на шаблон сообщения.
//  Предмет                  - Произвольный - объект основание для шаблона сообщений, типы объектов перечислены в
//                                            определяемом типе ПредметШаблонаСообщения.
//  УникальныйИдентификатор  - УникальныйИдентификатор - идентификатор формы, необходим для размещения вложений во
//                                            временном хранилище при клиент-серверном вызове. Если вызов
//                                            происходит только на сервере, то можно использовать любой идентификатор.
//  ДополнительныеПараметры  - Структура - список дополнительных параметров, который будет передан в параметр
//                                         Сообщение в процедурах ПриФормированииСообщения в момент создания сообщения:
//      * ЗначенияПараметровСКД - Структура - значения параметров СКД, состав и значения реквизитов
//                                            для формируемого шаблона определяется средствами СКД.
//      * ПреобразовыватьHTMLДляФорматированногоДокумента - Булево - необязательный, по умолчанию Ложь, определяет
//                      необходимо ли преобразование HTML текста сообщения содержащего картинки в тексте письма из-за
//                      особенностей вывода изображений в форматированном документе.
// 
// Возвращаемое значение:
//  Структура - подготовленное сообщение на основание шаблона для отправки:
//    * Тема - Строка - тема письма
//    * Текст - Строка - текст письма
//    * Получатель - СписокЗначений - получатели письма, где в значении электронная почта получателя, а
//                                    в представлении получатель письма.
//                 - Массив из см. НовыйПолучателиПисьма - если в процедуре ПриОпределенииНастроек 
//                   общего модуля ШаблоныСообщенийПереопределяемый свойство РасширенныйСписокПолучателей равно Истина.
//    * ДополнительныеПараметры - Структура - параметры шаблона сообщения.
//    * Вложения - ТаблицаЗначений:
//       ** Представление - Строка - имя файла вложения.
//       ** АдресВоВременномХранилище - Строка - адрес двоичных данных вложения во временном хранилище.
//       ** Кодировка - Строка - кодировка вложения (используется, если отличается от кодировки письма).
//       ** Идентификатор - Строка - необязательный,  идентификатор вложения, используется для хранения 
//                                   картинок, отображаемых в теле письма.
//
Функция СформироватьСообщение(Шаблон, Предмет, УникальныйИдентификатор, ДополнительныеПараметры = Неопределено) Экспорт

	ПараметрыОтправки = СформироватьПараметрыОтправки(Шаблон, Предмет, УникальныйИдентификатор, ДополнительныеПараметры);
	Возврат ШаблоныСообщенийСлужебный.СформироватьСообщение(ПараметрыОтправки);

КонецФункции

// Отправляет сообщение почты или SMS на основании предмета по шаблону сообщения.
//
// Параметры:
//  Шаблон                   - СправочникСсылка.ШаблоныСообщений - ссылка на шаблон сообщения.
//  Предмет                  - Произвольный - объект основание для шаблона сообщений, типы объектов перечислены в
//                                            определяемом типе ПредметШаблонаСообщения.
//  УникальныйИдентификатор  - УникальныйИдентификатор - идентификатор формы, необходим для размещения вложений во
//                                                       временном хранилище.
//  ДополнительныеПараметры  - см. ПараметрыОтправкиПисьмаПоШаблону
// 
// Возвращаемое значение:
//   см. ШаблоныСообщенийСлужебный.РезультатОтправкиПисьма
//
Функция СформироватьСообщениеИОтправить(Шаблон, Предмет, УникальныйИдентификатор,
	ДополнительныеПараметры = Неопределено) Экспорт

	ПараметрыОтправки = СформироватьПараметрыОтправки(Шаблон, Предмет, УникальныйИдентификатор, ДополнительныеПараметры);
	Возврат ШаблоныСообщенийСлужебный.СформироватьСообщениеИОтправить(ПараметрыОтправки);

КонецФункции

// Возвращает список обязательных дополнительных параметров, для процедуры СформироватьСообщениеИОтправить.
// Список параметров может быть расширен, для сквозной передачи в составе параметра Сообщение
// процедур ПриФормированииСообщения и последующего использования их значений при создании сообщения.
// 
// Возвращаемое значение:
//  Структура:
//   * ПреобразовыватьHTMLДляФорматированногоДокумента - Булево - необязательный, по умолчанию Ложь, определяет,
//                      необходимо ли преобразование HTML-текста сообщения, содержащего картинки в тексте письма, из-за
//                      особенностей вывода изображений в форматированном документе.
//   * УчетнаяЗапись - Неопределено
//                 - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - электронная почта
//                       для отправки письма, сформированного по шаблону.
//   * ОтправитьСразу - Булево - если Ложь, то письмо будет помещено в папку Исходящих 
//                                  и отправлено при общей отправке писем. Только при отправке через Взаимодействие.
//                                  Значение по умолчанию, Ложь.
//   * ЗначенияПараметровСКД - Структура - значения параметров СКД, состав и значения реквизитов
//                                         для формируемого шаблона определяется средствами СКД.
//
Функция ПараметрыОтправкиПисьмаПоШаблону() Экспорт

	ДополнительныеПараметры  = Новый Структура;

	ДополнительныеПараметры.Вставить("ПреобразовыватьHTMLДляФорматированногоДокумента", Ложь);
	ДополнительныеПараметры.Вставить("УчетнаяЗапись", Неопределено);
	ДополнительныеПараметры.Вставить("ОтправитьСразу", Ложь);
	ДополнительныеПараметры.Вставить("ЗначенияПараметровСКД", Новый Структура);

	Возврат ДополнительныеПараметры;

КонецФункции
//
// Заполняет список реквизитов шаблона сообщений на основание макета СКД.
//
// 	Параметры:
//    Реквизиты  - ДеревоЗначений - заполняемый список реквизитов.
//    Макет      - СхемаКомпоновкиДанных - макет СКД.
//
Процедура СформироватьСписокРеквизитовПоСКД(Реквизиты, Макет) Экспорт
	ШаблоныСообщенийСлужебный.РеквизитыПоСКД(Реквизиты, Макет);

КонецПроцедуры

// Заполняет список реквизитов шаблона сообщений на основании макета СКД.
//
// Параметры:
//  Реквизиты        - Соответствие - список реквизитов.
//  Предмет          - Произвольный - ссылка на объект основание для шаблона сообщений.
//  ПараметрыШаблона - см. ПараметрыШаблона.
//
Процедура ЗаполнитьРеквизитыПоСКД(Реквизиты, Предмет, ПараметрыШаблона) Экспорт
	ШаблоныСообщенийСлужебный.ЗаполнитьРеквизитыПоСКД(Реквизиты, Предмет, ПараметрыШаблона);
КонецПроцедуры

// Создать шаблон сообщения.
//
// Параметры:
//  Наименование     - Строка - наименование шаблона.
//  ПараметрыШаблона - см. ШаблоныСообщений.ОписаниеПараметровШаблона
//
// Возвращаемое значение:
//  СправочникСсылка.ШаблоныСообщений - ссылка на созданный шаблон.
//
Функция СоздатьШаблон(Наименование, ПараметрыШаблона) Экспорт

	ПараметрыШаблона.Вставить("Наименование", Наименование);

	ИмяСобытияЖурналаРегистрации = НСтр("ru = 'Создание шаблона сообщений'", ОбщегоНазначения.КодОсновногоЯзыка());

	НачатьТранзакцию();
	Попытка

		Шаблон = Справочники.ШаблоныСообщений.СоздатьЭлемент();
		Шаблон.Заполнить(ПараметрыШаблона);

		Если ОбновлениеИнформационнойБазы.ЭтоВызовИзОбработчикаОбновления() Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Шаблон, Истина);
		Иначе
			Шаблон.Записать();
		КонецЕсли;

		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда

			МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");

			Если ПараметрыШаблона.Вложения <> Неопределено Тогда
				Для Каждого Вложение Из ПараметрыШаблона.Вложения Цикл

					ИмяФайла = Новый Файл(Вложение.Ключ);

					ДополнительныеПараметры = Новый Структура;
					ДополнительныеПараметры.Вставить("Наименование", ИмяФайла.ИмяБезРасширения);
					Если СтрНайти(ПараметрыШаблона.Текст, ИмяФайла.ИмяБезРасширения) > 0 Тогда
						ДополнительныеПараметры.Вставить("ИДФайлаЭлектронногоПисьма", ИмяФайла.ИмяБезРасширения);
					КонецЕсли;

					ПараметрыДобавленияФайла = МодульРаботаСФайлами.ПараметрыДобавленияФайла(ДополнительныеПараметры);
					ПараметрыДобавленияФайла.ИмяБезРасширения = ИмяФайла.ИмяБезРасширения;
					Если СтрДлина(ИмяФайла.Расширение) > 1 Тогда
						ПараметрыДобавленияФайла.РасширениеБезТочки = Сред(ИмяФайла.Расширение, 2);
					КонецЕсли;
					ПараметрыДобавленияФайла.Автор = Пользователи.АвторизованныйПользователь();
					ПараметрыДобавленияФайла.ВладелецФайлов = Шаблон.Ссылка;

					Попытка
						МодульРаботаСФайлами.ДобавитьФайл(ПараметрыДобавленияФайла, Вложение.Значение);
					Исключение
						// Исключение может произойти в случае хранения файлов в томах, которые недоступны в момент записи файла.
						// В таком случае создаем шаблон без вложенных файлов.
						ИнформацияОбОшибке = ИнформацияОбОшибке();
						ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации, УровеньЖурналаРегистрации.Ошибка,,,
							ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
					КонецПопытки;
				КонецЦикла;
			КонецЕсли;

		КонецЕсли;

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации, УровеньЖурналаРегистрации.Ошибка,,,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));

		ВызватьИсключение;
	КонецПопытки;

	Возврат Шаблон.Ссылка;

КонецФункции

// Возвращает описание параметров шаблона.
// 
// Возвращаемое значение:
//  Структура:
//   * Наименование - Строка - наименование шаблона сообщений.
//   * Текст        - Строка - текст шаблона письма или сообщения SMS.
//   * Тема         - Строка - текст темы письма. Только для шаблонов электронной почты.
//   * ТипШаблона   - Строка - тип шаблона. Варианты: "Письмо","SMS".
//   * Назначение   - Строка - представление предмет шаблона сообщений. Например, Заказ покупателя.
//   * ПолноеИмяТипаНазначения - Строка - предмет шаблона сообщений. Если указан полный путь к объекту метаданных, то в шаблоне
//                                        в качестве параметров будут доступны все его реквизиты. Например, Документ.ЗаказПокупателя.
//   * ФорматПисьма    - ПеречислениеСсылка.СпособыРедактированияЭлектронныхПисем- формат письма HTML или обычный текст.
//                                         Только для шаблонов электронной почты.
//   * УпаковатьВАрхив - Булево - если Истина, то печатные формы и вложения будут упакованы в архив при отправке.
//                                Только для шаблонов электронной почты.
//   * ТранслитерироватьИменаФайлов - Булево - печатные формы и файлы, вложенные в письмо будут иметь имена, содержащие 
//                                             только латинские буквы и цифры, для возможности переноса между
//                                             различными операционными системами. Например, файл "Счет на оплату.pdf" будет
//                                             сохранен с именем "Schet na oplaty.pdf". Только для шаблонов электронной почты.
//   * ФорматыВложений - СписокЗначений - список форматов вложений. Только для шаблонов электронной почты.
//   * Вложения - Соответствие из КлючИЗначение:
//      ** Ключ - Строка - имя файла с расширением (например, image.png). Наименование будет без расширения.
//                         Или идентификатор картинки в html-письме (без cid).
//      ** Значение - Строка - адрес, указывающий на двоичные данные файла во временном хранилище.
//   * КомандыПечати - Массив из Строка - уникальные идентификаторы печатных форм
//   * ВладелецШаблона - ОпределяемыйТип.ВладелецШаблонаСообщения - владелец контекстного шаблона.
//   * ШаблонПоВнешнейОбработке - Булево - если Истина, то шаблон формируется внешней обработкой.
//   * ВнешняяОбработка - СправочникСсылка.ДополнительныеОтчетыИОбработки - внешняя обработка, в которой содержится шаблон.
//   * ПодписьИПечать   - Булево - добавляет факсимильную подпись и печать в печатную форму. Только для шаблонов
//                                 электронной почты.
//   * ДобавлятьПрисоединенныеФайлы - Булево - если Истина, то к вложениям письма будут добавлены все 
//                                              присоединенные файлы предмета-владельца.
//
Функция ОписаниеПараметровШаблона() Экспорт

	ПараметрыШаблона = ШаблоныСообщенийКлиентСервер.ОписаниеПараметровШаблона();
	ПараметрыШаблона.Удалить("РазворачиватьСсылочныеРеквизиты");

	Возврат ПараметрыШаблона;

КонецФункции

// Создает подчиненные реквизиты у ссылочного реквизита в дереве значений
//
// Параметры:
//  Имя					 - Строка - имя ссылочного реквизита, в дереве значений у которого необходимо добавить подчиненные реквизиты.
//  Узел				 - КоллекцияСтрокДереваЗначений - узел в дереве значений, для которого необходимо создать дочерние элементы.
//  СписокРеквизитов	 - Строка - список добавляемых реквизитов через запятую, если указано, то будет добавлены только они.
//  ИсключаяРеквизиты	 - Строка - список исключаемых реквизитов через запятую.
//
Процедура РазвернутьРеквизит(Имя, Узел, СписокРеквизитов = "", ИсключаяРеквизиты = "") Экспорт
	ШаблоныСообщенийСлужебный.РазвернутьРеквизит(Имя, Узел, СписокРеквизитов, ИсключаяРеквизиты);
КонецПроцедуры

// Добавляет актуальные адреса почты или номера телефонов из контактной информации объекта в список получателей.
// В выборку адресов почты или номеров телефонов попадают только актуальные сведения, 
// т.к. нет смысла отправлять письма или сообщения SMS на архивные данные. 
//
// Параметры:
//  ПолучателиПисьма        - ТаблицаЗначений - список получателей письма или сообщения SMS
//  ПредметСообщения        - Произвольный - объект-родитель, у которого есть реквизиты, содержащие контактную информацию.
//  ИмяРеквизита            - Строка - имя реквизита в объекте-родителе, из которого следует получить адреса почты или
//                                     номера телефонов.
//  ТипКонтактнойИнформации - ПеречислениеСсылка.ТипыКонтактнойИнформации - если тип Адрес, то будут добавлены адреса
//                                                                          почты, если Телефон, то номера телефонов.
//  ВариантОтправки - Строка - вариант отправки для получателя письма: Кому, Копия, СкрытаяКопия, ОбратныйАдрес;
//
Процедура ЗаполнитьПолучателей(ПолучателиПисьма, ПредметСообщения, ИмяРеквизита,
	ТипКонтактнойИнформации = Неопределено, ВариантОтправки = "Кому") Экспорт

	Если ТипЗнч(ПредметСообщения) = Тип("Структура") Тогда
		Предмет = ПредметСообщения.Предмет;
	Иначе
		Предмет = ПредметСообщения;
	КонецЕсли;
	МетаданныеОбъекта = Предмет.Метаданные();

	Если МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизита) = Неопределено Тогда
		Если Не ШаблоныСообщенийСлужебный.ЭтоСтандартныйРеквизит(МетаданныеОбъекта, ИмяРеквизита) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");

		Если Предмет[ИмяРеквизита] = Неопределено Тогда
			Возврат;
		КонецЕсли;

		Если ТипКонтактнойИнформации = Неопределено Тогда
			ТипКонтактнойИнформации = МодульУправлениеКонтактнойИнформацией.ТипКонтактнойИнформацииПоНаименованию(
				"АдресЭлектроннойПочты");
		КонецЕсли;

		ОбъектыКонтактнойИнформации = Новый Массив;
		ОбъектыКонтактнойИнформации.Добавить(Предмет[ИмяРеквизита]);

		КонтактнойИнформация = МодульУправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
			ОбъектыКонтактнойИнформации, ТипКонтактнойИнформации,, ТекущаяДатаСеанса());
		Для Каждого ЭлементКонтактнойИнформации Из КонтактнойИнформация Цикл
			Получатель = ПолучателиПисьма.Добавить();
			Если ТипКонтактнойИнформации = МодульУправлениеКонтактнойИнформацией.ТипКонтактнойИнформацииПоНаименованию(
				"Телефон") Тогда
				Получатель.НомерТелефона = ЭлементКонтактнойИнформации.Представление;
				Получатель.Представление = Строка(ЭлементКонтактнойИнформации.Объект);
				Получатель.Контакт       = ОбъектыКонтактнойИнформации[0];
			Иначе
				Получатель.Адрес           = ЭлементКонтактнойИнформации.Представление;
				Получатель.Представление   = Строка(ЭлементКонтактнойИнформации.Объект);
				Получатель.Контакт         = ОбъектыКонтактнойИнформации[0];
				Получатель.ВариантОтправки = ВариантОтправки;
			КонецЕсли;

		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

// Включает/выключает формирование сообщений по ранее созданным шаблонам.
//
// Параметры:
//   Значение - Булево - если Истина, то шаблоны сообщений доступны для использования.
//
Процедура УстановитьИспользованиеШаблоновСообщений(Значение) Экспорт

	Константы.ИспользоватьШаблоныСообщений.Установить(Значение);

КонецПроцедуры

// Проверяет возможность использования механизма шаблонов сообщений.
//
// Возвращаемое значение:
//   Булево - если Истина, то шаблоны сообщений доступны для использования.
//
Функция ИспользуютсяШаблоныСообщений() Экспорт

	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьШаблоныСообщений");

КонецФункции

// Программный интерфейс для внешних обработок.

// Создает описание таблицы параметров шаблона сообщения.
//
// Возвращаемое значение:
//   ТаблицаЗначений   - сформированная пустая таблица значений.
//
Функция ТаблицаПараметров() Экспорт

	ПараметрыШаблона = Новый ТаблицаЗначений;

	ПараметрыШаблона.Колонки.Добавить("ИмяПараметра", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(50,
		ДопустимаяДлина.Переменная)));
	ПараметрыШаблона.Колонки.Добавить("ОписаниеТипа", Новый ОписаниеТипов("ОписаниеТипов"));
	ПараметрыШаблона.Колонки.Добавить("ЭтоПредопределенныйПараметр", Новый ОписаниеТипов("Булево"));
	ПараметрыШаблона.Колонки.Добавить("ПредставлениеПараметра", Новый ОписаниеТипов("Строка", ,
		Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));

	Возврат ПараметрыШаблона;

КонецФункции

// Добавить параметр шаблона для внешней обработки.
//
// Параметры:
//  ТаблицаПараметров - ТаблицаЗначений - таблица со списком параметров.
//  ИмяПараметра - Строка - имя добавляемого параметра.
//  ОписаниеТипа - ОписаниеТипов - тип параметра.
//  ЭтоПредопределенныйПараметр - Булево - если Истина, то параметр предопределенный.
//  ПредставлениеПараметра - Строка - представление параметра.
//
Процедура ДобавитьПараметрШаблона(ТаблицаПараметров, ИмяПараметра, ОписаниеТипа, ЭтоПредопределенныйПараметр,
	ПредставлениеПараметра = "") Экспорт

	НоваяСтрока                             = ТаблицаПараметров.Добавить();
	НоваяСтрока.ИмяПараметра                = ИмяПараметра;
	НоваяСтрока.ОписаниеТипа                = ОписаниеТипа;
	НоваяСтрока.ЭтоПредопределенныйПараметр = ЭтоПредопределенныйПараметр;
	НоваяСтрока.ПредставлениеПараметра      = ?(ПустаяСтрока(ПредставлениеПараметра), ИмяПараметра,
		ПредставлениеПараметра);

КонецПроцедуры

// Инициализирует структуру Получатели для заполнения возможных получателей сообщения.
//
// Возвращаемое значение:
//   Структура  - созданная структура.
//
Функция ИнициализироватьСтруктуруПолучатели() Экспорт

	Возврат Новый Структура("Получатель", Новый Массив);

КонецФункции

// Инициализирует структуру сообщения по шаблону, которую должна вернуть внешняя обработка.
//
// Возвращаемое значение:
//   Структура  - созданная структура.
//
Функция ИнициализироватьСтруктуруСообщения() Экспорт

	СтруктураСообщения = Новый Структура;
	СтруктураСообщения.Вставить("ТекстСообщенияSMS", "");
	СтруктураСообщения.Вставить("ТемаПисьма", "");
	СтруктураСообщения.Вставить("ТекстПисьма", "");
	СтруктураСообщения.Вставить("СтруктураВложений", Новый Структура);
	СтруктураСообщения.Вставить("ТекстПисьмаHTML", "<HTML></HTML>");

	Возврат СтруктураСообщения;

КонецФункции

// Возвращает описание параметров шаблона сообщения по данным формы, ссылке на элемент справочника шаблона
// сообщения или определив контекстный шаблон по его владельцу. Если шаблон не будет найден, то будет возвращена
// структура с незаполненными полями шаблона сообщения, заполнив которые, можно создать новый шаблон сообщения.
//
// Параметры:
//  Шаблон - ДанныеФормыСтруктура
//         - СправочникСсылка.ШаблоныСообщений
//         - ЛюбаяСсылка - ссылка на шаблон сообщения или на владельца контекстного шаблона.
//
// Возвращаемое значение:
//   см. ШаблоныСообщенийКлиентСервер.ОписаниеПараметровШаблона.
//
Функция ПараметрыШаблона(Знач Шаблон) Экспорт

	ПоискПоВладельцу = Ложь;
	Если ТипЗнч(Шаблон) <> Тип("ДанныеФормыСтруктура") И ТипЗнч(Шаблон) <> Тип("СправочникСсылка.ШаблоныСообщений") Тогда

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШаблоныСообщений.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ШаблоныСообщений КАК ШаблоныСообщений
		|ГДЕ
		|	ШаблоныСообщений.ВладелецШаблона = &ВладелецШаблона";
		Запрос.УстановитьПараметр("ВладелецШаблона", Шаблон);

		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		Если РезультатЗапроса.Следующий() Тогда
			Шаблон = РезультатЗапроса.Ссылка;
		Иначе
			ПоискПоВладельцу = Истина;
		КонецЕсли;
	КонецЕсли;

	Результат = ШаблоныСообщенийСлужебный.ПараметрыШаблона(Шаблон);
	Если ПоискПоВладельцу Тогда
		Результат.ВладелецШаблона = Шаблон;
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Обратная совместимость.

// Подставляет в шаблон значения параметров сообщения и формирует текст сообщения.
//
// Параметры:
//  ШаблонСтроки        - Строка - шаблон, в который будут подставляться значения, согласно таблице параметров.
//  ВставляемыеЗначения - Соответствие - соответствие, содержащее ключи параметров и значения параметров.
//  Префикс             - Строка - префикс параметра.
//
// Возвращаемое значение:
//   Строка - строка, в которую были подставлены значения параметров шаблона.
//
Функция ВставитьПараметрыВСтрокуСогласноТаблицеПараметров(Знач ШаблонСтроки, ВставляемыеЗначения, Знач Префикс = "") Экспорт
	Возврат ШаблоныСообщенийСлужебный.ВставитьПараметрыВСтрокуСогласноТаблицеПараметров(ШаблонСтроки,
		ВставляемыеЗначения, Префикс);
КонецФункции

// Возвращает соответствие параметров текста сообщения шаблона.
//
// Параметры:
//  ПараметрыШаблона - Структура - сведения о шаблоне.
//
// Возвращаемое значение:
//  Соответствие - соответствие имеющихся в тексте сообщения параметров.
//
Функция ПараметрыИзТекстаСообщения(ПараметрыШаблона) Экспорт
	Возврат ШаблоныСообщенийСлужебный.ПараметрыИзТекстаСообщения(ПараметрыШаблона);
КонецФункции

// Заполняет общие реквизитов значениями из программы.
// После выполнения процедуры соответствие будет содержать значения:
//  ТекущаяДата, ЗаголовокСистемы, АдресБазыВИнтернете, АдресБазыВЛокальнойСети
//  ТекущийПользователь
//
// Параметры:
//  ОбщиеРеквизиты - Соответствие из КлючИЗначение:
//   * Ключ - Строка - имя общего реквизита
//   * Значение - Строка - значение заполненного реквизита.
//
Процедура ЗаполнитьОбщиеРеквизиты(ОбщиеРеквизиты) Экспорт
	ШаблоныСообщенийСлужебный.ЗаполнитьОбщиеРеквизиты(ОбщиеРеквизиты);
КонецПроцедуры

// Возвращает имя узла общих реквизитов.
// 
// Возвращаемое значение:
//  Строка - имя общего реквизита верхнего уровня.
//
Функция ИмяУзлаОбщихРеквизитов() Экспорт
	Возврат "ОбщиеРеквизиты";
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Определяет, является ли переданная ссылка элементом справочника шаблоны сообщений.
//
// Параметры:
//  ШаблонСсылка - СправочникСсылка.ШаблоныСообщений - ссылка на элемент справочника шаблоны сообщений.
// 
// Возвращаемое значение:
//  Булево - если Истина, то ссылка является элементом справочника шаблоны сообщений.
//
Функция ЭтоШаблон(ШаблонСсылка) Экспорт
	Возврат ТипЗнч(ШаблонСсылка) = Тип("СправочникСсылка.ШаблоныСообщений");
КонецФункции

// См. СозданиеНаОснованииПереопределяемый.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании.
Процедура ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Объекты) Экспорт

	Объекты.Добавить(Метаданные.Справочники.ШаблоныСообщений);

КонецПроцедуры

// См. СозданиеНаОснованииПереопределяемый.ПриДобавленииКомандСозданияНаОсновании.
Процедура ПриДобавленииКомандСозданияНаОсновании(Объект, КомандыСозданияНаОсновании, Параметры, СтандартнаяОбработка) Экспорт

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		Если Объект = Метаданные.Документы["ЭлектронноеПисьмоИсходящее"] Тогда
			Справочники.ШаблоныСообщений.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры отправки
// 
// Параметры:
//  Шаблон - СправочникСсылка.ШаблоныСообщений
//  Предмет - ОпределяемыйТип.ПредметШаблонаСообщения
//  УникальныйИдентификатор - УникальныйИдентификатор
//  ДополнительныеПараметры - Неопределено
//                          - Структура
//
// Возвращаемое значение:
//  Структура:
//    * ДополнительныеПараметры - Структура
//    * УникальныйИдентификатор - УникальныйИдентификатор
//    * Предмет - ОпределяемыйТип.ПредметШаблонаСообщения
//    * Шаблон - СправочникСсылка.ШаблоныСообщений
//
Функция СформироватьПараметрыОтправки(Шаблон, Предмет, УникальныйИдентификатор, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОтправки = ШаблоныСообщенийКлиентСервер.КонструкторПараметровОтправки(Шаблон, Предмет,
		УникальныйИдентификатор);

	Если ТипЗнч(ПараметрыОтправки.Предмет) = Тип("Строка") И ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(
		ПараметрыОтправки.Предмет) <> Неопределено Тогда

		ПараметрыОтправки.Предмет = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
			ПараметрыОтправки.Предмет).ПустаяСсылка();

	КонецЕсли;

	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения = ДополнительныеПараметры;
		
		// Если были переданы дополнительные параметры, то заменяем ими значения по умолчанию.
		Для Каждого Элемент Из ДополнительныеПараметры Цикл
			Если ПараметрыОтправки.ДополнительныеПараметры.Свойство(Элемент.Ключ) Тогда
				ПараметрыОтправки.ДополнительныеПараметры.Вставить(Элемент.Ключ, Элемент.Значение);
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;

	Возврат ПараметрыОтправки;

КонецФункции

// Возвращаемое значение:
//  Структура:
//    * Адрес - Строка - электронная почта получателя.
//    * Представление - Строка - представление получателя письма.
//    * ИсточникКонтактнойИнформации - ОпределяемыйТип.ПредметШаблонаСообщения - владелец контактной информации.
//                                   - Неопределено
//
Функция НовыйПолучателиПисьма() Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Адрес", "");
	Результат.Вставить("Представление", "");
	Результат.Вставить("ИсточникКонтактнойИнформации", Неопределено);

	Возврат Результат;

КонецФункции

// Параметры:
//  Вложения - ТаблицаЗначений
// Возвращаемое значение:
//   СтрокаТаблицыЗначений:
//   * Ссылка - СправочникСсылка.ШаблоныСообщенийПрисоединенныеФайлы
//   * Идентификатор - Строка
//   * Представление - Строка
//   * Выбрано - Булево
//   * ИндексКартинки - Число
//   * ТипФайла - Строка
//   * МенеджерПечати
//   * ПараметрыПечати
//   * Статус
//   * Имя
//   * Реквизит
//   * ИмяПараметра - Строка
//
Функция СтрокаВложений(Вложение) Экспорт
	Возврат Вложение;
КонецФункции

#КонецОбласти