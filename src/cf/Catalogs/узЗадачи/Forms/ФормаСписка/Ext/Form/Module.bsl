﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СкрыватьЗадачиСОпределеннымСтатусом = Истина;
	УстановитьВидимостьДоступность();
	УстановитьПараметрыСписка();
	ВыполнитьЛокализацию();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// +++ Шевченко 18.01.2024 +++
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	// --- Шевченко ---
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовШапкиФормы

&НаКлиенте
Процедура НаблюдательПриИзменении(Элемент)
	УстановитьПараметрыСписка();
КонецПроцедуры

&НаКлиенте
Процедура НомерЗадачиПриИзменении(Элемент)
	Если ЗначениеЗаполнено(НомерЗадачи) Тогда
		СкрыватьЗадачиСОпределеннымСтатусом = Ложь;
		Если Элементы.Список.Отображение <> ОтображениеТаблицы.Список Тогда
			Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		Конецесли;
	Иначе
		СкрыватьЗадачиСОпределеннымСтатусом = Истина;
	Конецесли;
	УстановитьПараметрыСписка();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСписка

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	// СтандартныеПодсистемы.Взаимодействие
	ВзаимодействияКлиент.СписокПредметПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	// Конец СтандартныеПодсистемы.Взаимодействие
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	// СтандартныеПодсистемы.Взаимодействие
	ВзаимодействияКлиент.СписокПредметПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	// Конец СтандартныеПодсистемы.Взаимодействие
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список, Список);	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьСкрытьЗадачи(Команда)
	СкрыватьЗадачиСОпределеннымСтатусом = НЕ СкрыватьЗадачиСОпределеннымСтатусом;
	УстановитьПараметрыСписка();
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьЛокализацию()
	МассивКодовСообщений = Новый Массив();
	МассивКодовСообщений.Добавить(70);//Наблюдатель
	
	РегистрыСведений.узСловарь.ВыполнитьЛокализацию(Элементы,МассивКодовСообщений);
КонецПроцедуры //ВыполнитьЛокализацию()

&НаСервере
Процедура УстановитьПараметрыСписка()
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьОтборПоНаблюдателю",ЗначениеЗаполнено(Наблюдатель));	
	Список.Параметры.УстановитьЗначениеПараметра("Наблюдатель",Наблюдатель);
	Список.Параметры.УстановитьЗначениеПараметра("СкрыватьЗадачиСОпределеннымСтатусом",СкрыватьЗадачиСОпределеннымСтатусом);
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьОтборПоНомеруЗадачи",ЗначениеЗаполнено(НомерЗадачи));	
	Список.Параметры.УстановитьЗначениеПараметра("НомерЗадачи",НомерЗадачи);	
	
	// _Демо начало примера
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователи.АвторизованныйПользователь());
	// _Демо конец примера	
КонецПроцедуры //УстановитьПараметрыСписка

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Элементы.ЕстьЗаметки.Видимость = Ложь;
	пИспользоватьЗаметки = Константы.ИспользоватьЗаметки.Получить(); 
	Если пИспользоватьЗаметки Тогда
		Элементы.ЕстьЗаметки.Видимость = Истина;
	Конецесли;
КонецПроцедуры 

#КонецОбласти
