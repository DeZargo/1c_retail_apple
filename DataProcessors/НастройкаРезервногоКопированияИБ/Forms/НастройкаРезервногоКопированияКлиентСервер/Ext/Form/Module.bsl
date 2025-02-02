﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ЭтоВебКлиент() Тогда
		ВызватьИсключение НСтр("ru = 'Резервное копирование недоступно в веб-клиенте.'");
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		Возврат; // Отказ устанавливается в ПриОткрытии().
	КонецЕсли;
	
	ПараметрыРезервногоКопирования = РезервноеКопированиеИБСервер.ПараметрыРезервногоКопирования();
	ОтключитьНапоминания = ПараметрыРезервногоКопирования.РезервноеКопированиеНастроено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ОбщегоНазначенияКлиент.ЭтоWindowsКлиент() Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Резервное копирование поддерживается только в клиенте под управлением ОС Windows.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"].ПараметрОповещения =
		?(ОтключитьНапоминания, "НеОповещать", "ЕщеНеНастроено");
	
	Если ОтключитьНапоминания Тогда
		РезервноеКопированиеИБКлиент.ОтключитьОбработчикОжиданияРезервногоКопирования();
	Иначе
		РезервноеКопированиеИБКлиент.ПодключитьОбработчикОжиданияРезервногоКопирования();
	КонецЕсли;
	
	ОКНаСервере();
	Оповестить("ЗакрытаФормаНастройкиРезервногоКопирования");
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОКНаСервере()
	
	ПараметрыРезервногоКопирования = РезервноеКопированиеИБСервер.ПараметрыРезервногоКопирования();
	
	ПараметрыРезервногоКопирования.РезервноеКопированиеНастроено = ОтключитьНапоминания;
	ПараметрыРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование = Ложь;
	
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

#КонецОбласти
