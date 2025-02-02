﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;	
			
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
    Документы.УдалитьСверткаИзУправляющейСистемы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
    ДенежныеСредстваСервер.ОтразитьДенежныеСредстваККМ(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваНаличные(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьПродажиПоДисконтнымКартам(ДополнительныеСвойства, Движения, Отказ);
	Ценообразование.ОтразитьЦеныНоменклатуры(ДополнительныеСвойства, Движения, Отказ);
	АссортиментСервер.ОтразитьКвотыАссортимента(ДополнительныеСвойства, Движения, Отказ);
	АссортиментСервер.ОтразитьАссортимент(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

КонецПроцедуры

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

КонецПроцедуры

// Процедура - обработчик события "ОбработкаПроверкиЗаполнения".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если СверкаДанных Тогда
		
		ТекстОшибки = НСтр("ru='Документ передан из управляющей системы для сверки данных,
		|проведение такого документа не предусмотрено'");
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
			
	КонецЕсли;
    	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		
		ТекстОшибки = НСтр("ru='Документ можно провести только в главном узле РИБ'");
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
			
	КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#КонецЕсли
