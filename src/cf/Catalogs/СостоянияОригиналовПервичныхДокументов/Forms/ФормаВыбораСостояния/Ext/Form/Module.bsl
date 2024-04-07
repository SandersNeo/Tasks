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

	СостоянияОригинала = УчетОригиналовПервичныхДокументов.ВсеСостояния();
	Для Каждого Состояние Из СостоянияОригинала Цикл 
		СписокСостоянийОригинала.Добавить(Состояние,,Ложь);
	КонецЦикла;
	СписокСостоянийОригинала.Добавить("СостояниеНеизвестно",НСтр("ru='<Состояние неизвестно>'"),Ложь);

	Если Параметры.Свойство("СписокСостояний") Тогда
		Для Каждого Состояние Из Параметры.СписокСостояний Цикл
			 НайденноеСостояние = СписокСостоянийОригинала.НайтиПоЗначению(Состояние.Значение);
			 Если Не НайденноеСостояние = Неопределено Тогда
				НайденноеСостояние.Пометка=Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;


КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)

	ОповеститьОВыборе(СписокСостоянийОригинала);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсеФлажки(Команда)

	Для Каждого ТекущийОтбор Из СписокСостоянийОригинала Цикл
		ТекущийОтбор.Пометка = Истина;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеФлажки(Команда)

	Для Каждого ТекущийОтбор Из СписокСостоянийОригинала Цикл
		ТекущийОтбор.Пометка = Ложь;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти