﻿
&НаСервере
&После("СканированиеОтгружаемойПродукцииПослеЗакрытияНаСервере")
Процедура КочетовСканированиеОтгружаемойПродукцииПослеЗакрытияНаСервере(АдресВременногоХранилища)
	
	
	
	
	
	
	Запрос=Новый запрос;
	Запрос.УстановитьПараметр("тч",Объект.Товары.Выгрузить());
	Запрос.Текст="ВЫБРАТЬ
	             |	тч.Справка2 КАК Справка2
	             |ПОМЕСТИТЬ тч
	             |ИЗ
	             |	&тч КАК тч
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ТТНВходящаяЕГАИСТовары.Справка2 КАК Справка2,
	             |	ТТНВходящаяЕГАИСТовары.Цена КАК Цена
	             |ИЗ
	             |	Документ.ТТНВходящаяЕГАИС.Товары КАК ТТНВходящаяЕГАИСТовары
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Справки2ЕГАИС КАК Справки2ЕГАИС
	             |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ тч КАК тч
	             |			ПО тч.Справка2 = Справки2ЕГАИС.Ссылка
	             |		ПО ТТНВходящаяЕГАИСТовары.Справка2 = Справки2ЕГАИС.Ссылка";
	
	
	Выборка=Запрос.Выполнить().Выбрать();
	
	Пока выборка.Следующий() цикл
		
		Отбор=Новый структура;
		Отбор.Вставить("справка2",выборка.справка2);
		строки=Объект.Товары.НайтиСтроки(Отбор);
		строки[0].цена=выборка.цена;
		строки[0].сумма=выборка.цена*строки[0].КоличествоУпаковок;
		
		
	КонецЦикла;
	
	
	
	
	
	
КонецПроцедуры

&НаСервере
Процедура КочетовПриСозданииНаСервереВместо(Отказ, СтандартнаяОбработка)
		УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаДокумента = ИнтеграцияЕГАИС.ПредставлениеВалютыРегламентированногоУчета();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормЕГАИСПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ТоварыХарактеристика");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ТоварыУпаковка");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ТоварыСерия");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСХарактеристикой(ЭтотОбъект, "ТоварыСерия");
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииПриЧтенииНаСервере();
		ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	КонецЕсли;
	
	// Режим отладки
	РежимОтладки = ОбщегоНазначенияКлиентСервер.РежимОтладки()
	             И Пользователи.ЭтоПолноправныйПользователь();
	
	//Элементы.СтраницаАкцизныеМарки.Видимость = РежимОтладки;
	Элементы.Идентификатор.Видимость         = РежимОтладки;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры
