﻿
#Область ПрограммныйИнтерфейс

// В функции требуется пересчитать количество введенных акцизных марок в количество единиц выбранной упаковки.
//
// Параметры:
//  Упаковка - ОпределяемыйТип.Упаковка - выбранная упаковка,
//  КоличествоАкцизныхМарок - Число - количество введенных акцизных марок,
//  КэшированныеЗначения - Струкктура, Неопределено - кэш формы документа.
//
// Возвращаемое значение:
//  Число - количество акцизных марок в единицах упаковки.
//
Функция КоличествоЕдиницАкцизныхМарок(Упаковка, КоличествоАкцизныхМарок, КэшированныеЗначения) Экспорт
	
	Возврат КоличествоАкцизныхМарок;
	
КонецФункции

Процедура ЗаполнитьПараметрыСканированияАкцизныхМарок(Параметры, Форма) Экспорт
	
	Если СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ЧекККМ") Тогда
		
		Если Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЧекККМ.Возврат") Тогда
			ЗаполнитьПараметрыСканированияАкцизныхМарокЧекККМВозврат(Параметры, Форма.Объект.ОрганизацияЕГАИС, Ложь);
		Иначе
			ЗаполнитьПараметрыСканированияАкцизныхМарокЧекККМ(Параметры, Форма.Объект.ОрганизацияЕГАИС, Ложь);
		КонецЕсли;
		
	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "ОбщаяФорма.ПроверкаЗаполненияДокументов") Тогда
		
		Если ТипЗнч(Форма.Ссылка) = Тип("ДокументСсылка.ЧекККМ") Тогда
			
			#Если Севрер Тогда
				ВидОперации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Форма.Ссылка, "ВидОперации");
			#Иначе
				ВидОперации = ОбщегоНазначенияРТВызовСервера.ЗначениеРеквизитаОбъекта(Форма.Ссылка, "ВидОперации");
			#КонецЕсли
			
			Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЧекККМ.Возврат") Тогда
				ЗаполнитьПараметрыСканированияАкцизныхМарокЧекККМВозврат(Параметры, Форма.Объект.ОрганизацияЕГАИС, Ложь);
			Иначе
				ЗаполнитьПараметрыСканированияАкцизныхМарокЧекККМ(Параметры, Форма.Объект.ОрганизацияЕГАИС, Ложь);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииРТ

Функция ЗаполнитьПараметрыСканированияАкцизныхМарокЧекККМ(Параметры, ОрганизацияЕГАИС, ПроверкаКоличества)
	
	Параметры.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
	Параметры.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
	
	Параметры.КонтрольАкцизныхМарок         = Истина;
	Параметры.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
	Параметры.ОперацияКонтроляАкцизныхМарок = "Продажа";
	
	Параметры.ОрганизацияЕГАИС              = ОрганизацияЕГАИС;
	Параметры.СоздаватьШтрихкодУпаковки     = Истина;
	
	Если ПроверкаКоличества Тогда
		Параметры.КлючевыеРеквизиты.Добавить("Штрихкод");
		Параметры.КлючевыеРеквизиты.Добавить("Помещение");
		Параметры.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
		Параметры.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
	Иначе
		Параметры.КлючевыеРеквизиты.Добавить("Цена");
		Параметры.КлючевыеРеквизиты.Добавить("СтавкаНДС");
		Параметры.КлючевыеРеквизиты.Добавить("Штрихкод");
		Параметры.КлючевыеРеквизиты.Добавить("Продавец");
		Параметры.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
		Параметры.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
	КонецЕсли;
	
КонецФункции

Функция ЗаполнитьПараметрыСканированияАкцизныхМарокЧекККМВозврат(Параметры, ОрганизацияЕГАИС, ПроверкаКоличества)
	
	Параметры.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Реализована"));
	Параметры.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
	
	Параметры.КонтрольАкцизныхМарок         = Истина;
	Параметры.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
	Параметры.ОперацияКонтроляАкцизныхМарок = "Возврат";
	Параметры.ОрганизацияЕГАИС              = ОрганизацияЕГАИС;
	Параметры.СоздаватьШтрихкодУпаковки     = Истина;
	
	Если ПроверкаКоличества Тогда
		Параметры.КлючевыеРеквизиты.Добавить("Штрихкод");
		Параметры.КлючевыеРеквизиты.Добавить("Помещение");
		Параметры.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
		Параметры.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
	Иначе
		Параметры.КлючевыеРеквизиты.Добавить("Цена");
		Параметры.КлючевыеРеквизиты.Добавить("СтавкаНДС");
		Параметры.КлючевыеРеквизиты.Добавить("Штрихкод");
		Параметры.КлючевыеРеквизиты.Добавить("Продавец");
		Параметры.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
		Параметры.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
	КонецЕсли;
	
КонецФункции

#КонецОбласти
