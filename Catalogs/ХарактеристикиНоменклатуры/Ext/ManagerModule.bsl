﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Перем ЗначениеИзСтруктуры;
	
	Если Параметры.Свойство("Номенклатура") Тогда
		Если Не Параметры.Свойство("Номенклатура", ЗначениеИзСтруктуры) Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли Параметры.Свойство("Владелец") Тогда
		Если Не Параметры.Свойство("Владелец", ЗначениеИзСтруктуры) И ТипЗнч(ЗначениеИзСтруктуры) <> Тип("СправочникСсылка.Номенклатура") Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Если Не ОбработкаТабличнойЧастиТоварыВызовСервера.ПроверитьИспользованиеХарактеристикИПолучитьСписокДляВыбора(ЗначениеИзСтруктуры,
	   ДанныеВыбора, Параметры.СтрокаПоиска) Тогда
		ДанныеВыбора = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
