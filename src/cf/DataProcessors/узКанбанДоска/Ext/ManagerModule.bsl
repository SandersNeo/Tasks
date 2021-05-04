﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ПорядковыйНомерЦветаЗадачи(Знач Важность, Знач СрокИсполнения, Знач НачалоРабот, Знач ОкончаниеРабот) Экспорт
	
	Результат = 4;
	
	Если Важность = ПредопределенноеЗначение("Справочник.узВариантыВажностиЗадачи.Высокая") Тогда
		
		Результат = 2;
		
	ИначеЕсли Важность = ПредопределенноеЗначение("Справочник.узВариантыВажностиЗадачи.Обычная") Тогда 
		
		БуферПроцент = 0;
		Если ЗначениеЗаполнено(СрокИсполнения) Тогда
			Если Не ЗначениеЗаполнено(ОкончаниеРабот) Тогда
				ОкончаниеРабот = ТекущаяДатаСеанса();
			КонецЕсли; 
			БуферПроцент = Цел((ОкончаниеРабот - НачалоРабот) / (СрокИсполнения - НачалоРабот) * 100);
		КонецЕсли; 
		
		Если БуферПроцент < 30 Тогда
			Результат = 4;
		ИначеЕсли БуферПроцент < 60 Тогда 
			Результат = 3;
		ИначеЕсли БуферПроцент < 100 Тогда 
			Результат = 2;
		Иначе
			Результат = 1;
		КонецЕсли; 
		
	ИначеЕсли Важность = ПредопределенноеЗначение("Справочник.узВариантыВажностиЗадачи.Низкая") Тогда 
		
		Результат = 10;
		
	КонецЕсли; 
	
	Возврат Результат;
		
КонецФункции

Функция ЧекЛистВыполнение(Знач Выполнено, Знач Всего) Экспорт
	
	Если Не ЗначениеЗаполнено(Всего) Тогда
		Возврат "";
	КонецЕсли; 
	
	Возврат СтрШаблон("%1/%2",
		Формат(Выполнено, "ЧН=; ЧГ="),
		Формат(Всего, "ЧН=; ЧГ="));
	
КонецФункции

Функция ЧекЛистВыполнениеПроцент(Знач Выполнено, Знач Всего) Экспорт
	
	Если Не ЗначениеЗаполнено(Всего) Тогда
		Возврат "";
	КонецЕсли; 
	
	Возврат Формат(Окр(Выполнено / Всего * 100, 1), "ЧН=; ЧГ=; ЧФ=Ч%");
	
КонецФункции

Функция УстановитьПараметр(НастройкиКомпоновки, Параметр, Значение = Неопределено, Использование = Истина) Экспорт
	
	Если ТипЗнч(Параметр) = Тип("Строка") Тогда
		ПараметрКомпоновки = Новый ПараметрКомпоновкиДанных(Параметр);
	Иначе
		ПараметрКомпоновки = Параметр;
	КонецЕсли; 
	
	ЗначениеПараметра = НастройкиКомпоновки.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрКомпоновки);
	
	Если ЗначениеПараметра <> Неопределено Тогда
		
		ЗначениеПараметра.Использование = Использование;
		ЗначениеПараметра.Значение = Значение;
		
	Конецесли;
	
	Возврат ЗначениеПараметра;
		
КонецФункции

Функция ДобавитьВыбранноеПоле(НастройкиКомпоновки, Поле, Использование = Истина) Экспорт
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		ПолеКомпоновки = Новый ПолеКомпоновкиДанных(Поле);
	Иначе
		ПолеКомпоновки = Поле;
	КонецЕсли; 
	
	ВыбранноеПоле = НастройкиКомпоновки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = ПолеКомпоновки;
	ВыбранноеПоле.Использование = Использование;
	
	Возврат ВыбранноеПоле;
		
КонецФункции

#КонецОбласти

#КонецЕсли