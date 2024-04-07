﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Функция формирует структуру, необходимую для установки индекса картинки в таблице событий журнала регистрации.
// 
// Возвращаемое значение:
//  ФиксированноеСоответствие из КлючИЗначение:
//   * Ключ - Строка
//   * Значение - Число
//
Функция НомераКартинокСобытий152ФЗ() Экспорт
	
	НомераКартинок = Новый Соответствие;
	НомераКартинок.Вставить("_$Session$_.Authentication",		1);
	НомераКартинок.Вставить("_$Session$_.AuthenticationError",	2);
	НомераКартинок.Вставить("_$Session$_.Start",				3);
	НомераКартинок.Вставить("_$Session$_.Finish",				4);
	НомераКартинок.Вставить("_$Access$_.Access",				5);
	НомераКартинок.Вставить("_$Access$_.AccessDenied",			6);
	
	Возврат Новый ФиксированноеСоответствие(НомераКартинок);
	
КонецФункции

// Возвращаемое значение:
//  ТаблицаЗначений:
//   * Объект - Строка
//   * ПоляРегистрации - Строка
//   * ПоляДоступа - Строка
//   * ОбластьДанных - Строка
//
Функция СведенияОПерсональныхДанных() Экспорт
	
	// Таблица сведений о персональных данных.
	ТаблицаСведений = Новый ТаблицаЗначений;
	ТаблицаСведений.Колонки.Добавить("Объект", 				Новый ОписаниеТипов("Строка"));
	ТаблицаСведений.Колонки.Добавить("ПоляРегистрации", 	Новый ОписаниеТипов("Строка"));
	ТаблицаСведений.Колонки.Добавить("ПоляДоступа", 		Новый ОписаниеТипов("Строка"));
	ТаблицаСведений.Колонки.Добавить("ОбластьДанных", 	Новый ОписаниеТипов("Строка"));
	
	// Сведения о персональных данных в самой подсистеме.
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.СогласиеНаОбработкуПерсональныхДанных";
	НовыеСведения.ПоляРегистрации	= "Субъект,ФИОСубъекта";
	НовыеСведения.ПоляДоступа		= "ФИОСубъекта,АдресСубъекта,ПаспортныеДанные,СрокДействия";
	НовыеСведения.ОбластьДанных		= "ОбработкаПерсональныхДанных";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "РегистрСведений.СогласияНаОбработкуПерсональныхДанных";
	НовыеСведения.ПоляРегистрации	= "Субъект";
	НовыеСведения.ПоляДоступа		= "СрокДействия";
	НовыеСведения.ОбластьДанных		= "ОбработкаПерсональныхДанных";
	
	// Заполнение таблицы сведений потребителями.
	ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений);
	
	Возврат ТаблицаСведений;
	
КонецФункции

// Возвращаемое значение:
//  ТаблицаЗначений:
//   * Имя - Строка
//   * Представление - Строка
//   * Родитель - Строка
//
Функция КатегорииПерсональныхДанных() Экспорт
	
	// Соответствие идентификаторов категорий и их пользовательских представлений.
	КатегорииДанных = Новый ТаблицаЗначений;
	КатегорииДанных.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	КатегорииДанных.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	КатегорииДанных.Колонки.Добавить("Родитель", Новый ОписаниеТипов("Строка"));
	
	НоваяКатегория = КатегорииДанных.Добавить();
	НоваяКатегория.Имя = "ОбработкаПерсональныхДанных";
	НоваяКатегория.Представление = НСтр("ru = 'Обработка ПДн'");
	
	// Заполнение категорий потребителями.
	ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьОбластиПерсональныхДанных(КатегорииДанных);
	
	Возврат КатегорииДанных;
	
КонецФункции

// Возвращает полные имена объектов метаданных, содержащих персональные данные.
//
// Возвращаемое значение:
//  Массив из Строка - например: "РегистрСведений.ДокументыФизическихЛиц".
//
Функция ИменаИсточниковПерсональныхДанных() Экспорт
	
	ТаблицаСведений = ЗащитаПерсональныхДанных.СведенияОПерсональныхДанных();
	ТаблицаСведений.Сортировать("Объект");
	
	ИменаИсточников = ТаблицаСведений.ВыгрузитьКолонку("Объект");
	ИменаИсточников = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ИменаИсточников);
	
	Возврат Новый ФиксированныйМассив(ИменаИсточников);
	
КонецФункции

// Возвращает таблицу значений с описанием полей объектов для уничтожения персональных данных.
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * Объект - Строка - полное имя объекта метаданных
//   * ПолеСубъект - Строка - полное имя поля Объекта со ссылкой на Субъект
//   * Поля - Массив из Строка, Строка - имена полей Объекта, в которых находятся персональные данные Субъекта
//   * КатегорияДанных - Строка - категория персональных данных
//
Функция УничтожаемыеПерсональныеДанные() Экспорт
	
	// Таблица сведений о персональных данных.
	ТаблицаСведений = Новый ТаблицаЗначений;
	ТаблицаСведений.Колонки.Добавить("Объект", Новый ОписаниеТипов("Строка"));
	ТаблицаСведений.Колонки.Добавить("ПолеСубъект", Новый ОписаниеТипов("Строка"));
	ТаблицаСведений.Колонки.Добавить("Поля", Новый ОписаниеТипов("Массив,Строка"));
	ТаблицаСведений.Колонки.Добавить("КатегорияДанных", Новый ОписаниеТипов("Строка"));
	
	ТаблицаСведений.Индексы.Добавить("Объект");
	
	// Сведения о персональных данных в самой подсистеме.
	ЗаполнитьСведенияОбУничтожаемыхПерсональныхДанных(ТаблицаСведений);
	
	// Заполнение таблицы сведений потребителями.
	ЗащитаПерсональныхДанныхПереопределяемый.ПриЗаполненииСведенийОбУничтожаемыхПерсональныхДанных(ТаблицаСведений);
	
	Возврат ТаблицаСведений;
	
КонецФункции

Процедура ЗаполнитьСведенияОбУничтожаемыхПерсональныхДанных(ТаблицаСведений)
	
	МетаданныеДокумента =  Метаданные.Документы.СогласиеНаОбработкуПерсональныхДанных;
	ИмяОбъекта = МетаданныеДокумента.ПолноеИмя();
	ИмяПоляСубъект = МетаданныеДокумента.Реквизиты.Субъект.ПолноеИмя();
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект = ИмяОбъекта;
	НовыеСведения.ПолеСубъект = ИмяПоляСубъект;
	НовыеСведения.Поля = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		МетаданныеДокумента.Реквизиты.ФИОСубъекта.ПолноеИмя());
	НовыеСведения.КатегорияДанных = "ФИО";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект = ИмяОбъекта;
	НовыеСведения.ПолеСубъект = ИмяПоляСубъект;
	НовыеСведения.Поля = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		МетаданныеДокумента.Реквизиты.АдресСубъекта.ПолноеИмя());
	НовыеСведения.КатегорияДанных = "МестоРегистрацииПроживания";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект = ИмяОбъекта;
	НовыеСведения.ПолеСубъект = ИмяПоляСубъект;
	НовыеСведения.Поля = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		МетаданныеДокумента.Реквизиты.ПаспортныеДанные.ПолноеИмя());
	НовыеСведения.КатегорияДанных = "ПаспортныеДанные";
	
КонецПроцедуры

// Возвращает представление категории персональных данных по имени.
// 
// Параметры:
//  ИмяКатегории - Строка
// 
// Возвращаемое значение:
//  Строка - представление категории персональных данных
//
Функция ПредставлениеКатегорииПерсональныхДанных(ИмяКатегории) Экспорт

	ПредставлениеКатегории = "";
	
	КатегорииПерсональныхДанных	= ЗащитаПерсональныхДанных.КатегорииПерсональныхДанных();
	НайденнаяСтрока = КатегорииПерсональныхДанных.Найти(ИмяКатегории, "Имя");
	Если НайденнаяСтрока <> Неопределено Тогда
		ПредставлениеКатегории = НайденнаяСтрока.Представление;
	КонецЕсли;
	
	Возврат ПредставлениеКатегории;
	
КонецФункции

// Возвращает полные имена реквизитов объекта метаданных содержащего персональные данные по его полному имени.
//
// Параметры:
//  ИмяИсточника - Строка - полное имя источника метаданных. Например: "Справочник.ФизическиеЛица".
//
// Возвращаемое значение:
//  Массив из Строка - пример: "ФизическоеЛицо" или "ФизическиеЛица.ФизическоеЛицо".
//
Функция ИменаРеквизитовИсточникаСодержащихСубъект(ИмяИсточника) Экспорт
	
	ПоляСведений = ИменаПолейСведенийОПерсональныхДанныхОбъекта(ИмяИсточника);
	ПоляСодержащиеСубъект = ПоляСведений.ПоляСодержащиеСубъект;
	ПоляПерсональныхДанных = ПоляСведений.ПоляПерсональныхДанных;
	
	ИменаРеквизитовСодержащихСубъект = Новый Массив; // Массив из Строка
	МетаданныеПоТипамСубъекта = ЗащитаПерсональныхДанных.МетаданныеПоТипамСубъекта();
	
	МетаданныеИсточника = Метаданные.НайтиПоПолномуИмени(ИмяИсточника); // ОбъектМетаданныхДокумент, ОбъектМетаданныхСправочник, ОбъектМетаданныхРегистрСведений
	ИсточникЭтоРегистр = ОбщегоНазначения.ЭтоРегистр(МетаданныеИсточника);
	ТипыСсылкиИсточника = ?(ИсточникЭтоРегистр, Новый Массив, МетаданныеИсточника.СтандартныеРеквизиты.Ссылка.Тип.Типы());
	ИсточникИмеетВладельца = ОбщегоНазначения.ЭтоСправочник(МетаданныеИсточника)
		И МетаданныеИсточника.Владельцы.Количество() > 0;
	
	ИменаТЧСодержащихСведения = Новый Массив; // Массив из Строка
	
	Если Не ИсточникЭтоРегистр Тогда
		
		ИменаТабличныхЧастей = Новый Массив; // Массив из Строка
		ТабличныеЧасти = МетаданныеИсточника.ТабличныеЧасти;
		
		Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
			ИменаТабличныхЧастей.Добавить(ТабличнаяЧасть.Имя);
		КонецЦикла;
		
		ИменаТЧСодержащихСведения = ИменаТЧОбъектаСодержащихСведенияОПерсональныхДанных(ИменаТабличныхЧастей,
			ПоляПерсональныхДанных, ПоляСодержащиеСубъект);
		
	КонецЕсли;
	
	Для Каждого ТипСубъектаИМетаданные Из МетаданныеПоТипамСубъекта Цикл
		
		ТипСубъекта = ТипСубъектаИМетаданные.Ключ; // Тип
		МетаданныеСубъекта = ТипСубъектаИМетаданные.Значение;
		
		ИменаРеквизитовИсточника = Новый Массив; // Массив из Строка
		ИменаРеквизитовТЧИсточника = Новый Соответствие;
		
		Если ИсточникЭтоРегистр Тогда
			
			ИменаИзмеренийТипа = ИменаИзмеренийРегистраПоТипу(МетаданныеИсточника, ТипСубъекта);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИменаРеквизитовИсточника, ИменаИзмеренийТипа);
			
		Иначе
			
			Если ТипыСсылкиИсточника.Найти(ТипСубъекта) <> Неопределено Тогда
				ИменаРеквизитовИсточника.Добавить("Ссылка");
			Иначе
				
				Если ИсточникИмеетВладельца Тогда
					
					Если МетаданныеИсточника.Владельцы.Содержит(МетаданныеСубъекта) Тогда
						ИменаРеквизитовИсточника.Добавить("Владелец");
					КонецЕсли;
					
				КонецЕсли;
				
				Если ИменаРеквизитовИсточника.Количество() = 0 Тогда
					
					ИменаРеквизитовТипа = ИменаРеквизитовПоТипу(МетаданныеИсточника, ТипСубъекта);
					ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИменаРеквизитовИсточника, ИменаРеквизитовТипа);
					
				КонецЕсли;
				
			КонецЕсли;
			
			Для Каждого ИмяТабличнойЧасти Из ИменаТЧСодержащихСведения Цикл
				
				ИменаРеквизитовТЧТипа = ИменаРеквизитовТЧОбъектаПоТипу(МетаданныеИсточника,	ИмяТабличнойЧасти,
					ТипСубъекта);
				Если ИменаРеквизитовТЧТипа.Количество() > 0 Тогда
					ИменаРеквизитовТЧИсточника.Вставить(ИмяТабличнойЧасти, ИменаРеквизитовТЧТипа);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Для Каждого ИмяРеквизита Из ИменаРеквизитовИсточника Цикл
			
			Если ПоляСодержащиеСубъект.Найти(ИмяРеквизита) <> Неопределено Тогда
				ИменаРеквизитовСодержащихСубъект.Добавить(ИмяРеквизита);
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого ТЧИРеквизиты Из ИменаРеквизитовТЧИсточника Цикл
			
			ИменаРеквизитовТЧ = ТЧИРеквизиты.Значение; // Массив из Строка
			Для Каждого ИмяРеквизита Из ИменаРеквизитовТЧ Цикл
				
				Если ПоляСодержащиеСубъект.Найти(ИмяРеквизита) <> Неопределено Тогда
					ИменаРеквизитовСодержащихСубъект.Добавить(ИмяРеквизита);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
		Если ИменаРеквизитовСодержащихСубъект.Количество() > 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(ИменаРеквизитовСодержащихСубъект);
	
КонецФункции

// Возвращает по полному имени объекта имена полей, содержащих уничтожаемые персональные данные субъекта,
// и имена полей, содержащих ссылку на субъекта.
// 
// Параметры:
//  ИмяОбъекта - Строка - полное имя объекта метаданных. Пример: "Справочник.ФизическиеЛица".
// 
// Возвращаемое значение:
//  Структура - имена полей скрываемых персональных данных объекта:
//   * ПоляПерсональныхДанных - Массив из Строка - например: "ИНН" или "ФизическиеЛица.ИНН".
//   * ПоляСодержащиеСубъект - Массив из Строка - например: "ФизическоеЛицо" или "ФизическиеЛица.ФизическоеЛицо".
//
Функция ИменаПолейСведенийОПерсональныхДанныхОбъекта(ИмяОбъекта)
	
	ИменаПолейСодержащихСубъект = Новый Массив; // Массив из Строка
	ИменаСкрываемыхПолей = Новый Массив; // Массив из Строка
	
	ТаблицаСведений = ЗащитаПерсональныхДанных.УничтожаемыеПерсональныеДанные();
	СтрокиСведений = ТаблицаСведений.НайтиСтроки(Новый Структура("Объект", ИмяОбъекта));
	
	Для Каждого СтрокаСведений Из СтрокиСведений Цикл
		
		Если ТипЗнч(СтрокаСведений.Поля) = Тип("Строка") Тогда
			СкрываемыеПоля = СтрРазделить(СтрокаСведений.Поля, ",");
		Иначе
			СкрываемыеПоля = СтрокаСведений.Поля;
		КонецЕсли;
		Для Каждого ИмяПоля Из СкрываемыеПоля Цикл
			ИменаСкрываемыхПолей.Добавить(КраткоеИмяПоля(ИмяПоля, ИмяОбъекта));
		КонецЦикла;
		
		ПоляСодержащиеСубъект = СтрРазделить(СтрокаСведений.ПолеСубъект, ",|");
		Для Каждого ИмяПоля Из ПоляСодержащиеСубъект Цикл
			ИменаПолейСодержащихСубъект.Добавить(КраткоеИмяПоля(ИмяПоля, ИмяОбъекта));
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Новый Структура("ПоляПерсональныхДанных,ПоляСодержащиеСубъект",
		ОбщегоНазначенияКлиентСервер.СвернутьМассив(ИменаСкрываемыхПолей),
		ОбщегоНазначенияКлиентСервер.СвернутьМассив(ИменаПолейСодержащихСубъект));
	
КонецФункции

Функция ИменаТЧОбъектаСодержащихСведенияОПерсональныхДанных(ИменаТЧОбъекта, Знач ИменаРеквизитов,
	Знач ПоляСодержащиеСубъект)
	
	ИменаТЧСодержащихСведения = Новый Массив; // Массив из Строка
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИменаРеквизитов, ПоляСодержащиеСубъект);
	
	Для Каждого ИмяТЧОбъекта Из ИменаТЧОбъекта Цикл
		
		ПодстрокаПоиска = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1.", ИмяТЧОбъекта);
		Для Каждого ИмяРеквизита Из ИменаРеквизитов Цикл
			
			Если СтрНайти(ИмяРеквизита, ПодстрокаПоиска) <> 0 Тогда
				
				ИменаТЧСодержащихСведения.Добавить(ИмяТЧОбъекта);
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ИменаТЧСодержащихСведения;
	
КонецФункции

// Преобразует полное имя поля в краткую форму.
// Например, "Документ.АктОбУничтоженииПерсональныхДанных.ТабличнаяЧасть.КатегорииДанных.Реквизит.ИмяОбъекта"
// преобразуется в "КатегорииДанных.ИмяОбъекта".
// 
// Параметры:
//  ПолноеИмяПоля - Строка, Произвольный - полное имя поля
//  ПолноеИмяОбъекта - Строка - полное имя объекта
// 
// Возвращаемое значение:
//  Строка - краткое имя поля
//
Функция КраткоеИмяПоля(ПолноеИмяПоля, ПолноеИмяОбъекта) Экспорт
	
	ИмяПоля = СтрЗаменить(СокрЛП(ПолноеИмяПоля), ПолноеИмяОбъекта, "");
	
	Если СтрНайти(ИмяПоля, ".ТабличнаяЧасть.") > 0 Тогда
		ИмяПоля = СтрЗаменить(СтрЗаменить(ИмяПоля, ".Реквизит.", "."), ".ТабличнаяЧасть.", "");
	Иначе
		ИмяПоля = СтрЗаменить(ИмяПоля, ".Реквизит.", "");
		ИмяПоля = СтрЗаменить(ИмяПоля, ".Измерение.", "");
		ИмяПоля = СтрЗаменить(ИмяПоля, ".Ресурс.", "");
	КонецЕсли;
	
	Возврат ИмяПоля;
	
КонецФункции

// Возвращаемое значение:
//   ФиксированноеСоответствие из КлючИЗначение:
//    * Ключ - Тип
//    * Значение -  ОбъектМетаданных
//
Функция МетаданныеПоТипамСубъекта() Экспорт
	
	ТипыСубъектов = ЗащитаПерсональныхДанных.ТипыСубъектов();
	
	МетаданныеПоТипуСубъектов = Новый Соответствие;
	Для Каждого ТипСубъекта Из ТипыСубъектов Цикл
		МетаданныеПоТипуСубъектов.Вставить(ТипСубъекта, Метаданные.НайтиПоТипу(ТипСубъекта));
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(МетаданныеПоТипуСубъектов);
	
КонецФункции

// Возвращаемое значение:
//   ФиксированныйМассив из Тип - типы субъектов персональных данных.
//
Функция ТипыСубъектов() Экспорт
	
	ТипыСубъектов = Метаданные.ОпределяемыеТипы.СубъектПерсональныхДанных.Тип.Типы();
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ТипыСубъектов,
		Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	
	Возврат Новый ФиксированныйМассив(ТипыСубъектов);
	
КонецФункции

Функция ТипыСубъектовДоступныхПоФункциональнымОпциям() Экспорт
	
	Результат = Новый Массив;
	
	ТипыСубъектов = ЗащитаПерсональныхДанных.ТипыСубъектов();
	
	Для Каждого ТипСубъекта Из ТипыСубъектов Цикл
		ИмяМетаданных = Метаданные.НайтиПоТипу(ТипСубъекта).ПолноеИмя();
		Если ЗащитаПерсональныхДанных.СубъектДоступенПоФункциональнымОпциям(ИмяМетаданных) Тогда
			Результат.Добавить(ТипСубъекта);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

// Возвращаемое значение:
//   ФиксированныйМассив из Строка - полные имена объектов метаданных
//
Функция ИменаМетаданныхПоТипамСубъекта() Экспорт
	
	ТипыСубъектов = ЗащитаПерсональныхДанных.ТипыСубъектов();
	
	ИменаМетаданных = Новый Массив; // Массив из Строка
	Для Каждого ТипСубъекта Из ТипыСубъектов Цикл
		ИменаМетаданных.Добавить(Метаданные.НайтиПоТипу(ТипСубъекта).ПолноеИмя());
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(ИменаМетаданных);
	
КонецФункции

// Параметры:
//  МетаданныеОбъекта - ОбъектМетаданныхДокумент, ОбъектМетаданныхСправочник
//  Тип - Тип
// 
// Возвращаемое значение:
//  Массив из Строка
//
Функция ИменаРеквизитовПоТипу(МетаданныеОбъекта, Тип)
	
	ИменаРеквизитов = Новый Массив; // Массив из Строка
	
	Для Каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		Если Реквизит.Тип.СодержитТип(Тип) Тогда
			ИменаРеквизитов.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИменаРеквизитов;
	
КонецФункции

// Параметры:
//  МетаданныеОбъекта - ОбъектМетаданныхДокумент, ОбъектМетаданныхСправочник
//  ИмяТабличнойЧасти - Строка
//  Тип - Тип
// 
// Возвращаемое значение:
//  Массив из Строка
//
Функция ИменаРеквизитовТЧОбъектаПоТипу(МетаданныеОбъекта, ИмяТабличнойЧасти, Тип)
	
	ИменаРеквизитов = Новый Массив; // Массив из Строка
	МетаданныеТЧ = МетаданныеОбъекта.ТабличныеЧасти.Найти(ИмяТабличнойЧасти);
	
	Если МетаданныеТЧ <> Неопределено Тогда
		Для Каждого Реквизит Из МетаданныеТЧ.Реквизиты Цикл
			Если Реквизит.Тип.СодержитТип(Тип) Тогда
				ИменаРеквизитов.Добавить(ИмяТабличнойЧасти + "." + Реквизит.Имя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ИменаРеквизитов;
	
КонецФункции

// Параметры:
//  МетаданныеРегистра - ОбъектМетаданныхРегистрСведений
//  Тип - Тип
// 
// Возвращаемое значение:
//  Массив из Строка
//
Функция ИменаИзмеренийРегистраПоТипу(МетаданныеРегистра, Тип)
	
	ИменаИзмерений = Новый Массив; // Массив из Строка
	
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		
		Если Измерение.Тип.СодержитТип(Тип) Тогда
			ИменаИзмерений.Добавить(Измерение.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИменаИзмерений;
	
КонецФункции

// Определяет доступен ли объект по функциональным опциям.
// 
// Параметры:
//  ИмяСубъекта - Строка - полное имя объекта метаданных субъекта
// 
// Возвращаемое значение:
//  Булево
//
Функция СубъектДоступенПоФункциональнымОпциям(ИмяСубъекта) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяСубъекта);
	ОбъектВходитВСоставФункциональныхОпций = Ложь;
	
	Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		Если Не ФункциональнаяОпция.Состав.Содержит(ОбъектМетаданных) Тогда
			Продолжить;
		КонецЕсли;
		ОбъектВходитВСоставФункциональныхОпций = Истина;
		Если ПолучитьФункциональнуюОпцию(ФункциональнаяОпция.Имя) = Истина Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ОбъектВходитВСоставФункциональныхОпций Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
