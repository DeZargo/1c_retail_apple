﻿
#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ПровестиНепроведенныеДокументы(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		МассивНепроведенныхДокументов = ФормированиеПечатныхФормВызовСервера.ПровестиДокументы(ДополнительныеПараметры.МассивНепроведенныхДокументов);
		ОткрытьФормуРаспределенияТоваров(ДополнительныеПараметры.ПараметрКоманды, МассивНепроведенныхДокументов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураДанных = ПодготовитьСтруктуруДанных(ПараметрКоманды);
	
	Если СтруктураДанных.ИспользоватьОрдернуюСхемуПриПоступлении Тогда
		
		МассивДокументов = Новый Массив;
		МассивДокументов.Добавить(ПараметрКоманды);
		МассивНепроведенныхДокументов = ФормированиеПечатныхФормВызовСервера.ПолучитьМассивНепроведенныхДокументов(МассивДокументов);
		
		Если МассивНепроведенныхДокументов.Количество() > 0 Тогда
			
			ТекстВопроса = НСтр("ru = 'Распределение товаров по складам возможно
			|только после проведения документа, провести документ?'");
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("МассивНепроведенныхДокументов", МассивНепроведенныхДокументов);
			ДополнительныеПараметры.Вставить("ПараметрКоманды", ПараметрКоманды);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ПровестиНепроведенныеДокументы", ЭтотОбъект, ДополнительныеПараметры);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		Иначе
			ОткрытьФормуРаспределенияТоваров(ПараметрКоманды, МассивНепроведенныхДокументов)
		КонецЕсли;
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Для магазина %Магазин% распределение поступления товаров по складам не требуется.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Магазин%", СтруктураДанных.Магазин);
		ПоказатьПредупреждение(,ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция формирует структуру с параметрами для вызова обработки.
//
&НаСервере
Функция ПодготовитьСтруктуруДанных(ПараметрКоманды)
		
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Магазин",                                ПараметрКоманды.МагазинПолучатель);
	СтруктураПараметры.Вставить("Склад",                                  ПараметрКоманды.СкладПолучатель);
	СтруктураПараметры.Вставить("ИспользоватьОрдернуюСхемуПриПоступлении",ПараметрКоманды.МагазинПолучатель.ИспользоватьОрдернуюСхемуПриПеремещении);
	СтруктураПараметры.Вставить("Документ",          ПараметрКоманды);
	СтруктураПараметры.Вставить("Режим",             "ПриходТовара");
	
	Возврат СтруктураПараметры;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуРаспределенияТоваров(ПараметрКоманды, МассивНепроведенныхДокументов)
	
	Если МассивНепроведенныхДокументов.Количество() = 0 Тогда
		СтруктураДанных = ПодготовитьСтруктуруДанных(ПараметрКоманды);
		ОткрытьФорму("Обработка.РаспределениеТоваровПоСкладам.Форма.Форма", СтруктураДанных,, Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
