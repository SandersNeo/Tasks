﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Проект") Тогда
		ЗаполнитьЗначенияСвойств(Запись, Параметры);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
