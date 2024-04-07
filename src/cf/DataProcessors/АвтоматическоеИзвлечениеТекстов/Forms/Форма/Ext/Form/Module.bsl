﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ЭтоВебКлиент() Или Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		Возврат; // Отказ устанавливается в ПриОткрытии().
	КонецЕсли;
	
	ВключеноИзвлечениеТекста = Ложь;
	
	ИнтервалВремениВыполнения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения");
	Если ИнтервалВремениВыполнения = 0 Тогда
		ИнтервалВремениВыполнения = 60;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	КонецЕсли;
	
	КоличествоФайловВПорции = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АвтоматическоеИзвлечениеТекстов", "КоличествоФайловВПорции");
	Если КоличествоФайловВПорции = 0 Тогда
		КоличествоФайловВПорции = 100;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "КоличествоФайловВПорции",  КоличествоФайловВПорции);
	КонецЕсли;
	
	Элементы.ИнформацияОКоличествеФайловСНеизвлеченнымТекстом.Заголовок = ТекстСостоянияПодсчет();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ИзвлечениеТекстовДоступно() Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Извлечение текстов поддерживается только в клиенте под управлением ОС Windows.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ОбновитьИнформациюОКоличествеФайловСНеизвлеченнымТекстом();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалВремениВыполненияПриИзменении(Элемент)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	
	Если ВключеноИзвлечениеТекста Тогда
		ОтключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик");
		ПрогнозируемоеВремяНачалаИзвлечения = ОбщегоНазначенияКлиент.ДатаСеанса() + ИнтервалВремениВыполнения;
		ПодключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик", ИнтервалВремениВыполнения);
		ОбновлениеОбратногоОтсчета();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоФайловВПорцииПриИзменении(Элемент)
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "КоличествоФайловВПорции",  КоличествоФайловВПорции);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Старт(Команда)
	
	ВключеноИзвлечениеТекста = Истина; 
	
	ПрогнозируемоеВремяНачалаИзвлечения = ОбщегоНазначенияКлиент.ДатаСеанса();
	ПодключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик", ИнтервалВремениВыполнения);
	
#Если НЕ ВебКлиент И НЕ МобильныйКлиент Тогда
	ИзвлечениеТекстовКлиентОбработчик();
#КонецЕсли
	
	ПодключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета", 1);
	ОбновлениеОбратногоОтсчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Стоп(Команда)
	ВыполнитьСтоп();
КонецПроцедуры

&НаКлиенте
Процедура ИзвлечьВсе(Команда)
	
	#Если НЕ ВебКлиент И НЕ МобильныйКлиент Тогда
		КоличествоФайловСНеизвлеченнымТекстомДоНачалаОперации = КоличествоФайловСНеизвлеченнымТекстом;
		Статус = "";
		РазмерПорции = 0; // извлечь все
		ИзвлечениеТекстовКлиент(РазмерПорции);
		
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Завершено извлечение текста из
			         |всех файлов с неизвлеченным текстом.
			         |
			         |Обработано файлов: %1.'"),
			КоличествоФайловСНеизвлеченнымТекстомДоНачалаОперации));
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ИзвлечениеТекстовДоступно()
	
#Если ВебКлиент Или МобильныйКлиент Тогда
	Возврат Ложь;
#Иначе
	Возврат ОбщегоНазначенияКлиент.ЭтоWindowsКлиент();
#КонецЕсли
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСостоянияПодсчет()
	Возврат НСтр("ru = 'Поиск файлов с неизвлеченным текстом...'");
КонецФункции

&НаКлиенте
Процедура ОбновитьИнформациюОКоличествеФайловСНеизвлеченнымТекстом()
	
	ОтключитьОбработчикОжидания("НачатьОбновлениеИнформацииОКоличествеФайловСНеизвлеченнымТекстом");
	Если ТекущееФоновоеЗадание = "Подсчет" И ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
		ПрерватьФоновоеЗадание();
	КонецЕсли;
	ПодключитьОбработчикОжидания("НачатьОбновлениеИнформацииОКоличествеФайловСНеизвлеченнымТекстом", 2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьФоновоеЗадание()
	ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	ТекущееФоновоеЗадание = "";
	ИдентификаторФоновогоЗадания = "";
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания)
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда 
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеИнформацииОКоличествеФайловСНеизвлеченнымТекстом()
	
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
		Элементы.ИнформацияОКоличествеФайловСНеизвлеченнымТекстом.Заголовок = ТекстСостоянияПодсчет();
		Возврат;
	КонецЕсли;
	
	Элементы.ИнформацияОКоличествеФайловСНеизвлеченнымТекстом.Заголовок = ТекстСостоянияПодсчет();
	ДлительнаяОперация = ВыполнитьПоискФайловСНеизвлеченнымТекстом();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииОбновленияИнформацииОКоличествеФайловСНеизвлеченнымТекстом", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииОбновленияИнформацииОКоличествеФайловСНеизвлеченнымТекстом(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Поиск файлов с неизвлеченным текстом'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
			"Ошибка", Результат.ПодробноеПредставлениеОшибки, , Истина);
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;

	ИдентификаторФоновогоЗадания = "";
	ВывестиИнформациюОКоличествеФайловСНеизвлеченнымТекстом();
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиИнформациюОКоличествеФайловСНеизвлеченнымТекстом()
	
	ИнформацияОКоличествеФайловСНеизвлеченнымТекстом = ПолучитьИзВременногоХранилища(АдресРезультата);
	Если ИнформацияОКоличествеФайловСНеизвлеченнымТекстом = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоФайловСНеизвлеченнымТекстом = ИнформацияОКоличествеФайловСНеизвлеченнымТекстом;
	
	Если КоличествоФайловСНеизвлеченнымТекстом > 0 Тогда
		Элементы.ИнформацияОКоличествеФайловСНеизвлеченнымТекстом.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Количество файлов с неизвлеченным текстом: %1'"),
			КоличествоФайловСНеизвлеченнымТекстом);
	Иначе
		Элементы.ИнформацияОКоличествеФайловСНеизвлеченнымТекстом.Заголовок = НСтр("ru = 'Количество файлов с неизвлеченным текстом: нет'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьПоискФайловСНеизвлеченнымТекстом()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Поиск файлов с неизвлеченным текстом.'");
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "РаботаСФайламиСлужебный.КоличествоВерсийСНеизвлеченнымТекстом");
	ТекущееФоновоеЗадание = "Подсчет";
	ИдентификаторФоновогоЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	АдресРезультата = ДлительнаяОперация.АдресРезультата;
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписьЖурналаРегистрацииСервер(ТекстСообщения)
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Файлы.Извлечение текста'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеОбратногоОтсчета()
	
	Осталось = ПрогнозируемоеВремяНачалаИзвлечения - ОбщегоНазначенияКлиент.ДатаСеанса();
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'До начала извлечения текстов осталось %1 сек'"),
		Осталось);
	
	Если Осталось <= 1 Тогда
		ТекстСообщения = "";
	КонецЕсли;
	
	ИнтервалВремениВыполнения = Элементы.ИнтервалВремениВыполнения.ТекстРедактирования;
	Статус = ТекстСообщения;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзвлечениеТекстовКлиентОбработчик()
	
#Если НЕ ВебКлиент И НЕ МобильныйКлиент Тогда
	ИзвлечениеТекстовКлиент();
#КонецЕсли

КонецПроцедуры

#Если Не ВебКлиент И Не МобильныйКлиент Тогда
	
// Извлекает текст из файлов для полнотекстового поиска.
&НаКлиенте
Процедура ИзвлечениеТекстовКлиент(РазмерПорции = Неопределено)
	
	ПрогнозируемоеВремяНачалаИзвлечения = ОбщегоНазначенияКлиент.ДатаСеанса() + ИнтервалВремениВыполнения;
	
	Попытка
		
		РазмерПорцииТекущий = КоличествоФайловВПорции;
		Если РазмерПорции <> Неопределено Тогда
			РазмерПорцииТекущий = РазмерПорции;
		КонецЕсли;
		МассивФайлов = ПолучитьФайлыДляИзвлеченияТекста(РазмерПорцииТекущий);
		
		Если МассивФайлов.Количество() = 0 Тогда
			ПоказатьОповещениеПользователя(НСтр("ru = 'Извлечение текстов'"),, НСтр("ru = 'Нет файлов для извлечения текста'"));
			Возврат;
		КонецЕсли;
		
		Для Индекс = 0 По МассивФайлов.Количество() - 1 Цикл
			
			Расширение = МассивФайлов[Индекс].Расширение;
			НаименованиеФайла = МассивФайлов[Индекс].Наименование;
			ФайлИлиВерсияФайла = МассивФайлов[Индекс].Ссылка;
			Кодировка = МассивФайлов[Индекс].Кодировка;
			
			Попытка
				АдресФайла = ПолучитьНавигационнуюСсылкуФайла(
					ФайлИлиВерсияФайла, УникальныйИдентификатор);
				
				ИмяСРасширением = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
					НаименованиеФайла, Расширение);
				
				Прогресс = Индекс * 100 / МассивФайлов.Количество();
				Состояние(НСтр("ru = 'Идет извлечение текста файла'"), Прогресс, ИмяСРасширением);
				
				РаботаСФайламиСлужебныйКлиент.ИзвлечьТекстВерсии(
					ФайлИлиВерсияФайла, АдресФайла, Расширение, УникальныйИдентификатор, Кодировка);
			
			Исключение
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Непредвиденная ситуация при извлечении текста из файла ""%1"":
						|%2'"),
					Строка(ФайлИлиВерсияФайла), ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				Состояние(ТекстСообщения);
				РезультатИзвлечения = "ИзвлечьНеУдалось";
				ЗаписьОшибкиИзвлечения(ФайлИлиВерсияФайла, РезультатИзвлечения, ТекстСообщения);
			КонецПопытки;
			
		КонецЦикла;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Извлечение текста завершено.
			           |Обработано файлов: %1'"),
			МассивФайлов.Количество());		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Извлечение текстов'"),, ТекстСообщения);
		
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Непредвиденная ситуация при извлечении текста из файла ""%1"":
			|%2'"),
			Строка(ФайлИлиВерсияФайла), ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));	
		ПоказатьОповещениеПользователя(НСтр("ru = 'Извлечение текстов'"),, ТекстСообщения);	
		ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
	КонецПопытки;
	
	ОбновитьИнформациюОКоличествеФайловСНеизвлеченнымТекстом();
	
КонецПроцедуры

#КонецЕсли

&НаСервереБезКонтекста
Процедура ЗаписьОшибкиИзвлечения(ФайлИлиВерсияФайла, РезультатИзвлечения, ТекстСообщения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РаботаСФайламиСлужебный.ЗаписатьРезультатИзвлеченияТекста(ФайлИлиВерсияФайла, РезультатИзвлечения, "");
	
	// Запись в журнал регистрации.
	ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
	
КонецПроцедуры


// Параметры:
//   КоличествоФайловВПорции - Число
// Возвращаемое значение:
//   Массив из Структура:
//   * Ссылка - ОпределяемыйТип.ПрисоединенныйФайл
//   * Расширение - Строка
//   * Наименование - Строка
//   * Кодировка - Строка 
//
&НаСервереБезКонтекста
Функция ПолучитьФайлыДляИзвлеченияТекста(КоличествоФайловВПорции)
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	ПолучитьВсеФайлы = (КоличествоФайловВПорции = 0);
	
	Запрос = Новый Запрос;
	Запрос.Текст = РаботаСФайламиСлужебный.ТекстЗапросаДляИзвлеченияТекста(ПолучитьВсеФайлы, Истина);
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Строка Из Выгрузка Цикл
		
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Ссылка",       Строка.Ссылка);
		СтруктураСтроки.Вставить("Расширение",   Строка.Расширение);
		СтруктураСтроки.Вставить("Наименование", Строка.Наименование);
		СтруктураСтроки.Вставить("Кодировка",    Строка.Кодировка);
		
		Результат.Добавить(СтруктураСтроки);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНавигационнуюСсылкуФайла(Знач ФайлИлиВерсияФайла, Знач УникальныйИдентификатор)
	
	Возврат РаботаСФайламиСлужебный.НавигационнойСсылкиФайла(ФайлИлиВерсияФайла,
		УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьСтоп()
	ОтключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик");
	ОтключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета");
	Статус = "";
	ВключеноИзвлечениеТекста = Ложь;
КонецПроцедуры

#КонецОбласти
