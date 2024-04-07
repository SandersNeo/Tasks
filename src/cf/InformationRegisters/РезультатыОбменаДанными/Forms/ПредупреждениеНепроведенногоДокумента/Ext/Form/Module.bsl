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
	
	Параметры.Свойство("ПроблемныйОбъект", ПроблемныйОбъект);
	Параметры.Свойство("Описание", Описание);
	Параметры.Свойство("ТипПредупреждения", ТипПредупреждения);
	Параметры.Свойство("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Параметры.Свойство("СкрытьПредупреждение", СкрытьПредупреждение);
	Параметры.Свойство("ДатаВозникновения", ДатаВозникновения);
	Параметры.Свойство("ОбъектМетаданных", ОбъектМетаданных);
	Параметры.Свойство("КлючУникальности", КлючУникальностиЗаписиРегистраСведений);
	Параметры.Свойство("КомментарийПредупреждения", КомментарийПредупреждения);
	
	ТребуетсяОбновлениеПризнакаСкрытьИзСписка = Ложь;
	ТребуетсяОбновлениеКомментария = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьКартинкуДекорации()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкрытьПредупреждениеПриИзменении(Элемент)
	
	ТребуетсяОбновлениеПризнакаСкрытьИзСписка = Истина;
	
	Если СкрытьПредупреждение Тогда
		
		Элементы.ДекорацияКартинка.Картинка = БиблиотекаКартинок.Информация32;
		
	Иначе
		
		Элементы.ДекорацияКартинка.Картинка = БиблиотекаКартинок.Ошибка32;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроблемныйОбъектНажатие(Элемент, СтандартнаяОбработка)
	
	ТребуетсяОбновлениеПризнакаСкрытьИзСписка = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПредупрежденияПриИзменении(Элемент)
	
	ТребуетсяОбновлениеКомментария = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ПередЗакрытиемНаСервере();
	
	Если ТребуетсяОбновлениеПризнакаСкрытьИзСписка
		ИЛИ ТребуетсяОбновлениеКомментария Тогда
		
		Закрыть(Новый Структура("ТребуетсяОбновлениеСписка", Истина));
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ТребуетсяОбновлениеПризнакаСкрытьИзСписка = Истина;
	
	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	
	ПровестиДокументы(ПроблемныйОбъект, СообщениеОбОшибке);
	
	Если НЕ ПустаяСтрока(СообщениеОбОшибке) Тогда
		
		ПоказатьПредупреждение(, СообщениеОбОшибке);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьКартинкуДекорации()
	
	Если СкрытьПредупреждение Тогда
		
		Элементы.ДекорацияКартинка.Картинка = БиблиотекаКартинок.Информация32;
		
	Иначе
		
		Элементы.ДекорацияКартинка.Картинка = БиблиотекаКартинок.Ошибка32;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗакрытиемНаСервере()
	
	Если НЕ ТребуетсяОбновлениеПризнакаСкрытьИзСписка
		И НЕ ТребуетсяОбновлениеКомментария Тогда
		
		Возврат;
		
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.РезультатыОбменаДанными.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ТипПроблемы = ТипПредупреждения;
	МенеджерЗаписи.УзелИнформационнойБазы = УзелИнформационнойБазы;
	МенеджерЗаписи.ОбъектМетаданных = ОбъектМетаданных;
	МенеджерЗаписи.ПроблемныйОбъект = ПроблемныйОбъект;
	МенеджерЗаписи.КлючУникальности = КлючУникальностиЗаписиРегистраСведений;
	
	МенеджерЗаписи.Прочитать(); // читаем для сохранения реквизитов, которые не передаем на форму
	Если НЕ МенеджерЗаписи.Выбран() Тогда
		
		// Сценарий: открыли карточку предупреждения, а параллельно поправили проблему
		Возврат;
		
	КонецЕсли;
	
	МенеджерЗаписи.ДатаВозникновения = ДатаВозникновения;
	МенеджерЗаписи.Комментарий = КомментарийПредупреждения;
	МенеджерЗаписи.Пропущена = СкрытьПредупреждение;
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПровестиДокументы(ПроблемныйОбъект, СообщениеОбОшибке)
	
	НачатьТранзакцию();
	Попытка
		
		ЗаблокироватьДанныеДляРедактирования(ПроблемныйОбъект);
		
		ДокументОбъект = ПроблемныйОбъект.ПолучитьОбъект();
		Если ДокументОбъект.ПроверитьЗаполнение() Тогда
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ШаблонСообщения = НСтр("ru = 'Не удалось провести документ ""%1"" по причине:%2 %3.'", ОбщегоНазначения.КодОсновногоЯзыка());
		ПредставлениеОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПроблемныйОбъект, Символы.ПС, ПредставлениеОшибки));
			
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
