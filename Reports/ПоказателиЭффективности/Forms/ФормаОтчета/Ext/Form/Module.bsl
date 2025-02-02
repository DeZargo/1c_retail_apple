﻿&НаКлиенте
Перем ДатаНачала;
&НаКлиенте
Перем ДатаОкончания;
&НаКлиенте
Перем ДатаНачалаПрошлыйПериод;
&НаКлиенте
Перем ДатаОкончанияПрошлыйПериод;
&НаКлиенте
Перем ДатаНачалаПрошлыйПериодОтображаемыеПериоды;
&НаКлиенте
Перем ДатаОкончанияОтображаемыеПериоды;
&НаКлиенте
Перем ДатаОкончанияДляРасчетаДнейТорговли;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УчитыватьСебестоимость = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьУчетСебестоимости");
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	АдресХранилищаСКД = ПоместитьВоВременноеХранилище(ОтчетОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных"), Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПериодыОтчета();
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ВариантыОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ДатаОтчета                     = Настройки.Получить("ДатаОтчета");
	КоличествоОтображаемыхПериодов = Настройки.Получить("КоличествоОтображаемыхПериодов");
	Периодичность                  = Настройки.Получить("Периодичность");
	
	Если НЕ ЗначениеЗаполнено(ДатаОтчета) Тогда
		ДатаОтчета = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(КоличествоОтображаемыхПериодов) Тогда
		КоличествоОтображаемыхПериодов = 1;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Периодичность) Тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаОтчетаПриИзменении(Элемент)
	
	УстановитьПериодыОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоОтображаемыхПериодовПриИзменении(Элемент)
	
	УстановитьПериодыОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(
		ДанныеРасшифровки, 
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресХранилищаСКД)
	);
	
	СтруктураЗначений = ПолучитьЗначениеПоляРасшифровки(Расшифровка);
	ВыполненноеДействие = Неопределено;
	ПараметрВыполненногоДействия = Неопределено;
	ДополнительноеМеню = Новый СписокЗначений();
	Если СтруктураЗначений.ПоказательБудетРасшифровывается = Истина Тогда
		Если СтруктураЗначений.ВыводитьДинамику = Истина Тогда
			ДополнительноеМеню.Добавить("РасшифровкаДинамика", НСтр("ru = 'Расшифровка показателя в динамике'"));
		КонецЕсли;
		Если СтруктураЗначений.ВыводитьИнтервалы = Истина Тогда
			ДополнительноеМеню.Добавить("РасшифровкаПериоды", НСтр("ru = 'Расшифровка показателя по интервалам'"));
		КонецЕсли;
	КонецЕсли;
	
	ДоступныеДействия = Новый Массив;
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрВыполненногоДействия", ПараметрВыполненногоДействия);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеВыбораДействия", ЭтотОбъект, ДополнительныеПараметры);
	
	ОбработкаРасшифровки.ПоказатьВыборДействия(
		ОписаниеОповещения,
		Расшифровка, 
		ВыполненноеДействие, 
		ПараметрВыполненногоДействия, 
		ДоступныеДействия,
		ДополнительноеМеню
	);
		
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалПриИзменении(Элемент)
	
	УстановитьПериодыОтчета();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	СформироватьОтчетСервер(ПолучитьПараметрыОтчета(Ложь, Ложь));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОповещениеВыбораДействия(ВыполненноеДействие, НастройкиКомпоновкиДанных , ДополнительныеПараметры) Экспорт
	
	ПараметрВыполненногоДействия = ДополнительныеПараметры.ПараметрВыполненногоДействия;
	Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
		ПоказатьЗначение(, ПараметрВыполненногоДействия);
	ИначеЕсли ВыполненноеДействие = "РасшифровкаДинамика" ИЛИ ВыполненноеДействие = "РасшифровкаПериоды" Тогда
		РассчитыватьДинамику = (ВыполненноеДействие = "РасшифровкаДинамика");
		СтруктураЗначений = ПолучитьПараметрыОтчета(Истина, РассчитыватьДинамику, СтруктураЗначений);
		СтруктураЗначений.Вставить("Расшифровка", ВыполненноеДействие);
		СформироватьРасшифровкуНаСервере(СтруктураЗначений);
		СтруктураЗначений.ТабличныйДокумент.Показать();
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает периоды для формирования отчета.
//
&НаКлиенте
Процедура УстановитьПериодыОтчета()
	
	Если НЕ ЗначениеЗаполнено(Периодичность) Тогда
		Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц");
	КонецЕсли;
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		ДатаНачалаПрошлыйПериодОтображаемыеПериоды = НачалоМесяца(ДобавитьМесяц(ДатаОтчета, - (КоличествоОтображаемыхПериодов - 1)));
		ДатаОкончанияОтображаемыеПериоды = КонецМесяца(ДатаОтчета);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		ДатаНачалаПрошлыйПериодОтображаемыеПериоды = НачалоНедели(ДатаОтчета) - (КоличествоОтображаемыхПериодов - 1) * 7 * 86400;
		ДатаОкончанияОтображаемыеПериоды = КонецНедели(ДатаОтчета);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		Если День(ДатаОтчета)%10 = 0 Тогда
			НомерДекады = День(ДатаОтчета) / 10;
			НомерДекадыТекущая = День(ДатаОтчета) / 10;
		Иначе
			Если Цел(День(ДатаОтчета) / 10) = 3 Тогда
				НомерДекады = 3;
				НомерДекадыТекущая = 3;
			Иначе
				НомерДекады = Цел(День(ДатаОтчета) / 10 + 1);
				НомерДекадыТекущая = Цел(День(ДатаОтчета) / 10 + 1);
			КонецЕсли;
		КонецЕсли;
		
		Если НомерДекады > КоличествоОтображаемыхПериодов - 1 Тогда
			КоличествоМесяцевНазадВКоторыйПопадаетРасчетнаяДекада = 0;
			НомерДекады = НомерДекады - (КоличествоОтображаемыхПериодов - 1);
		Иначе
			КоличествоДекадЗаПределомТекМесяца = (КоличествоОтображаемыхПериодов) - НомерДекады;
			Если КоличествоДекадЗаПределомТекМесяца % 3 = 0 Тогда
				КоличествоМесяцевНазадВКоторыйПопадаетРасчетнаяДекада = КоличествоДекадЗаПределомТекМесяца / 3;
			Иначе
				КоличествоМесяцевНазадВКоторыйПопадаетРасчетнаяДекада = Цел(КоличествоДекадЗаПределомТекМесяца / 3) + 1;
			КонецЕсли;
			ЗначениеДляРасчетаДекады = Цел(КоличествоДекадЗаПределомТекМесяца / 3);
			ЗначениеДляРасчетаДекады = ЗначениеДляРасчетаДекады * 3;
			ЗначениеДляРасчетаДекады = КоличествоДекадЗаПределомТекМесяца - ЗначениеДляРасчетаДекады;
			Если ЗначениеДляРасчетаДекады % 3 = 0 Тогда
				НомерДекады = 1;
			Иначе
				Если ЗначениеДляРасчетаДекады = 1 Тогда
					НомерДекады = 3;
				Иначе
					НомерДекады = 2;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если НомерДекады = 1 Тогда
			деньНачалоДекады = 1;
		ИначеЕсли НомерДекады = 2 Тогда
			деньНачалоДекады = 11;
		ИначеЕсли НомерДекады = 3 Тогда
			деньНачалоДекады = 21;
		КонецЕсли;
		Если НомерДекадыТекущая = 1 Тогда
			деньКонецДекады = 10;
		ИначеЕсли НомерДекадыТекущая = 2 Тогда
			деньКонецДекады = 20;
		ИначеЕсли НомерДекадыТекущая = 3 Тогда
			деньКонецДекады = День(КонецМесяца(ДатаОтчета));
		КонецЕсли;
		
		МесяцВКоторомНаходитсяНужнаяДекада = ДобавитьМесяц(ДатаОтчета, - КоличествоМесяцевНазадВКоторыйПопадаетРасчетнаяДекада);
		
		ДатаНачалаПрошлыйПериодОтображаемыеПериоды = Дата(Год(МесяцВКоторомНаходитсяНужнаяДекада), Месяц(МесяцВКоторомНаходитсяНужнаяДекада), деньНачалоДекады);
		ДатаОкончанияОтображаемыеПериоды = КонецДня(Дата(Год(ДатаОтчета), Месяц(ДатаОтчета), деньКонецДекады));
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		ДатаНачалаПрошлыйПериодОтображаемыеПериоды = НачалоДня(ДатаОтчета) - (КоличествоОтображаемыхПериодов - 1) * 86400;
		ДатаОкончанияОтображаемыеПериоды = КонецДня(ДатаОтчета);
	КонецЕсли;
		
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		ДатаНачала = НачалоМесяца(ДатаОтчета);
		ДатаОкончания = КонецМесяца(ДатаОтчета);
		Если НЕ АналогичныйПериод Тогда
			ДатаНачалаПрошлыйПериод = НачалоМесяца(ДобавитьМесяц(ДатаОтчета, -1));
			ДатаОкончанияПрошлыйПериод = КонецМесяца(ДобавитьМесяц(ДатаОтчета, -1));
		Иначе
			ДатаНачалаПрошлыйПериод = НачалоМесяца(ДобавитьМесяц(ДатаОтчета, -12));
			ДатаОкончанияПрошлыйПериод = КонецМесяца(ДобавитьМесяц(ДатаОтчета, -12));
		КонецЕсли;
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		ДатаНачала = НачалоНедели(ДатаОтчета);
		ДатаОкончания = КонецНедели(ДатаОтчета);
		Если НЕ АналогичныйПериод Тогда
			ДатаНачалаПрошлыйПериод = НачалоНедели(НачалоНедели(ДатаОтчета) - 1);
			ДатаОкончанияПрошлыйПериод = КонецНедели(НачалоНедели(ДатаОтчета) - 1);
		Иначе
			ДатаНачалаПрошлыйПериод = ДобавитьМесяц(ДатаНачала, -12);
			ДатаОкончанияПрошлыйПериод = ДобавитьМесяц(ДатаОкончания, -12);
		КонецЕсли;
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		Если День(ДатаОтчета)%10 = 0 Тогда
			НомерДекады = День(ДатаОтчета) / 10;
		Иначе
			Если Цел(День(ДатаОтчета) / 10) = 3 Тогда
				НомерДекады = 3;
			Иначе
				НомерДекады = Цел(День(ДатаОтчета) / 10 + 1);
			КонецЕсли;
		КонецЕсли;
		
		Если НомерДекады = 1 Тогда
			деньНачалоДекады = 1;
			деньКонецДекады = 10;
			
			МесяцПрошлойДекады = Месяц(ДобавитьМесяц(ДатаОтчета, -1));
			ГодПрошлойДекады = Год(ДобавитьМесяц(ДатаОтчета, -1));
			деньНачалоПрошлойДекады = 21;
			деньКонецДекадыПрошлыйПериод = День(КонецМесяца(ДобавитьМесяц(ДатаОтчета, -1)));
		ИначеЕсли НомерДекады = 2 Тогда
			деньНачалоДекады = 11;
			деньКонецДекады = 20;
			
			МесяцПрошлойДекады = Месяц(ДатаОтчета);
			ГодПрошлойДекады = Год(ДатаОтчета);
			деньНачалоПрошлойДекады = 1;
			деньКонецДекадыПрошлыйПериод = 10;
		ИначеЕсли НомерДекады = 3 Тогда
			деньНачалоДекады = 21;
			деньКонецДекады = День(КонецМесяца(ДатаОтчета));
			
			МесяцПрошлойДекады = Месяц(ДатаОтчета);
			ГодПрошлойДекады = Год(ДатаОтчета);
			деньНачалоПрошлойДекады = 11;
			деньКонецДекадыПрошлыйПериод = 20;
		КонецЕсли;
		ДатаНачала = НачалоДня(Дата(Год(ДатаОтчета), Месяц(ДатаОтчета), деньНачалоДекады));
		ДатаОкончания = КонецДня(Дата(Год(ДатаОтчета), Месяц(ДатаОтчета), деньКонецДекады));
		
		Если НЕ АналогичныйПериод Тогда
			ДатаНачалаПрошлыйПериод = НачалоДня(Дата(ГодПрошлойДекады, МесяцПрошлойДекады, деньНачалоПрошлойДекады));
			ДатаОкончанияПрошлыйПериод = КонецДня(Дата(ГодПрошлойДекады, МесяцПрошлойДекады, деньКонецДекадыПрошлыйПериод));
		Иначе
			ДатаНачалаПрошлыйПериод = ДобавитьМесяц(ДатаНачала, -12);
			Если ДатаОкончания = КонецМесяца(ДатаОкончания) Тогда
				ДатаОкончанияПрошлыйПериод = КонецМесяца(ДобавитьМесяц(ДатаОкончания, -12));
			Иначе
				ДатаОкончанияПрошлыйПериод = ДобавитьМесяц(ДатаОкончания, -12);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		ДатаНачала = НачалоДня(ДатаОтчета);
		ДатаОкончания = КонецДня(ДатаОтчета);
		Если НЕ АналогичныйПериод Тогда
			ДатаНачалаПрошлыйПериод = НачалоДня(НачалоДня(ДатаОтчета) - 1);
			ДатаОкончанияПрошлыйПериод = КонецДня(НачалоДня(ДатаОтчета) - 1);
		Иначе
			ДатаНачалаПрошлыйПериод = ДобавитьМесяц(ДатаНачала, -12);
			ДатаОкончанияПрошлыйПериод = ДобавитьМесяц(ДатаОкончания, -12);
		КонецЕсли;
	КонецЕсли;
	
	НадписьЗначениеИнтервалаПредыдущийПериод = Формат(ДатаНачалаПрошлыйПериод, "ДФ=dd.MM.yy; ДЛФ=DD") + " - " + Формат(ДатаОкончанияПрошлыйПериод, "ДФ=dd.MM.yy; ДЛФ=DD");
	НадписьЗначениеИнтервалаТекущийПериод = Формат(ДатаНачала, "ДФ=dd.MM.yy; ДЛФ=DD") + " - " + Формат(ДатаОкончания, "ДФ=dd.MM.yy; ДЛФ=DD");
	НадписьЗначениеОтображаемыхИнтервалов = Формат(ДатаНачалаПрошлыйПериодОтображаемыеПериоды, "ДФ=dd.MM.yy; ДЛФ=DD") + " - " + Формат(ДатаОкончанияОтображаемыеПериоды, "ДФ=dd.MM.yy; ДЛФ=DD");
	
	ТекущаяДата = КонецДня(ОбщегоНазначенияКлиент.ДатаСеанса());
	Элементы.НадписьЗначениеИнтервалаПредыдущийПериод.ЦветТекста = ?(ДатаОкончанияПрошлыйПериод > ТекущаяДата,Новый Цвет(255,0,0), Новый Цвет());
	Элементы.НадписьЗначениеИнтервалаТекущийПериод.ЦветТекста = ?(ДатаОкончания > ТекущаяДата,Новый Цвет(255,0,0), Новый Цвет());
	ДатаОкончанияДляРасчетаДнейТорговли = ?(ДатаОкончания > ТекущаяДата, ТекущаяДата, ДатаОкончания);
	
КонецПроцедуры

// Процедура устанавливает тип дополнения и периоды для группировки отчета по выбранному значению реквизита
// Периодичность.
// Параметры:
// ПолеГруппировкиКомпоновкиДанных - Тип ПолеГруппировкиКомпоновкиДанных - поле группировки для которого
//                                   устанавливается тип дополнения и периоды начала и окончания.
// СтруктураПараметров - Тип Структура - содержит необходимые параметры для реализации алгоритма процедуры.
//
&НаСервере
Процедура УстановитьТипДополненияДляГруппировкиПериод(ПолеГруппировкиКомпоновкиДанных, СтруктураПараметров)
	
	ТипДополнения = ТипДополненияПериодаКомпоновкиДанных.БезДополнения;
	Если СтруктураПараметров.Периодичность = Перечисления.Периодичность.Месяц Тогда
		ТипДополнения = ТипДополненияПериодаКомпоновкиДанных.Месяц;
	ИначеЕсли СтруктураПараметров.Периодичность = Перечисления.Периодичность.Декада Тогда
		ТипДополнения = ТипДополненияПериодаКомпоновкиДанных.Декада;
	ИначеЕсли СтруктураПараметров.Периодичность = Перечисления.Периодичность.Неделя Тогда
		ТипДополнения = ТипДополненияПериодаКомпоновкиДанных.Неделя;
	ИначеЕсли СтруктураПараметров.Периодичность = Перечисления.Периодичность.День Тогда
		ТипДополнения = ТипДополненияПериодаКомпоновкиДанных.День;
	КонецЕсли;
	ПолеГруппировкиКомпоновкиДанных.ТипДополнения = ТипДополнения;
	ПолеГруппировкиКомпоновкиДанных.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
	ПолеГруппировкиКомпоновкиДанных.НачалоПериода = СтруктураПараметров.ДатаНачалаЧекиККМ;
	ПолеГруппировкиКомпоновкиДанных.КонецПериода = СтруктураПараметров.КонецПериода;
	
КонецПроцедуры

// Процедура устанавливает параметры компоновщику настроек.
// Параметры:
// СтруктураПараметров - Тип Структура - содержит необходимые параметры для реализации алгоритма процедуры.
// ЭтоРасшифровка - Тип Булево - признак вызова процедуры при формировании расшифровки.
// КомпоновщикНастроекКомпоновкиДанных - Тип КомпоновщикНастроекКомпоновкиДанных - Настройки компоновки для которых
//                                       необходимо установить параметры, если процедура вызвана при формировании
//                                       расшифровки в процедуру передается значение параметра.
//
&НаСервере
Процедура УстановитьПараметрыКомпоновщикуНастроекСервер(СтруктураПараметров, ЭтоРасшифровка = Ложь, КомпоновщикНастроекКомпоновкиДанных = Неопределено)
	
	Если КомпоновщикНастроекКомпоновкиДанных = Неопределено Тогда
		КомпоновщикНастроекКомпоновкиДанных = Отчет.КомпоновщикНастроек;
	КонецЕсли;
	
	Для Каждого Параметр Из СтруктураПараметров Цикл
		ЗначениеПараметра = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыДанных.Элементы.Найти(Параметр.Ключ);
		Если ЗначениеПараметра <> Неопределено Тогда
			ЗначениеПараметра.Использование = Истина;
			ЗначениеПараметра.Значение = Параметр.Значение;
		КонецЕсли;
	КонецЦикла;
		
	Если НЕ ЭтоРасшифровка Тогда
		// Заполнение параметров для предопределенных настроек.
		Для Каждого ЭлементСтруктурыОтчета Из КомпоновщикНастроекКомпоновкиДанных.Настройки.Структура Цикл
			Если ТипЗнч(ЭлементСтруктурыОтчета) = Тип("ДиаграммаКомпоновкиДанных") Тогда
				МаксКоличествоТочки = ЭлементСтруктурыОтчета.Точки.Количество() - 1;
				МаксКоличество = Макс(МаксКоличествоТочки);
				Для итератор = 0 По МаксКоличество Цикл
					Если итератор <= МаксКоличествоТочки Тогда
						Для Каждого ПолеГруппировкиКомпоновкиДанных Из ЭлементСтруктурыОтчета.Точки[итератор].ПоляГруппировки.Элементы Цикл
							Если ПолеГруппировкиКомпоновкиДанных.Поле = Новый ПолеКомпоновкиДанных("ПериодЧековККМ") Тогда
								УстановитьТипДополненияДляГруппировкиПериод(ПолеГруппировкиКомпоновкиДанных, СтруктураПараметров);
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура формирует отчет
//
&НаСервере
Процедура СформироватьОтчетСервер(СтруктураПараметров)
	
	УстановитьПараметрыКомпоновщикуНастроекСервер(СтруктураПараметров);
	СкомпоноватьРезультат();
	
КонецПроцедуры

// Функция получает структуру для заполнения параметров компоновке данных при формировании основного отчета или
// расшифровки.
// Параметры:
// СтруктураПараметров - Тип Структура - Содержащая ключи с наименованиями параметров схемы компоновки данных.
// ЭтоРасшифровка - Тип Булево - признак формирования основного отчета равен Ложь, отчета расшифровки равен Истина.
// РассчитыватьДинамику - Тип Булево - признак влияющий на установку временных интервалов для запросов.
//
&НаКлиенте
Функция ПолучитьПараметрыОтчета(ЭтоРасшифровка, РассчитыватьДинамику, СтруктураПараметров = Неопределено)
	
	Если СтруктураПараметров = Неопределено Тогда
		СтруктураПараметров = Новый Структура();
	КонецЕсли;
	
	СтруктураПараметров.Вставить("НачалоПериода", ДатаНачала);
	СтруктураПараметров.Вставить("КонецПериода", ДатаОкончания);
	СтруктураПараметров.Вставить("ДатаНачалаПрошлыйПериод", ДатаНачалаПрошлыйПериод);
	СтруктураПараметров.Вставить("ДатаОкончанияПрошлыйПериод", ДатаОкончанияПрошлыйПериод);
	СтруктураПараметров.Вставить("ДатаНачалаЧекиККМ", ДатаНачалаПрошлыйПериодОтображаемыеПериоды);
	Если ЭтоРасшифровка Тогда
		Если РассчитыватьДинамику Тогда
			СтруктураПараметров.Вставить("ДатаНачалаРасшифровка", ДатаНачалаПрошлыйПериод);
		Иначе
			СтруктураПараметров.Вставить("ДатаНачалаРасшифровка", ДатаНачалаПрошлыйПериодОтображаемыеПериоды);
		КонецЕсли;
	Иначе
		СтруктураПараметров.Вставить("ДатаНачалаРасшифровка", ДатаНачалаПрошлыйПериод);
	КонецЕсли;
	СтруктураПараметров.Вставить("УчитыватьСебестоимость", УчитыватьСебестоимость);
	СтруктураПараметров.Вставить("Периодичность", Периодичность);
	СтруктураПараметров.Вставить("ЭтоРасшифровка", ЭтоРасшифровка);
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Процедура получает поля для выбранного поля расшифровки.
// Параметры:
// ЭлементРасшифровки - Тип ЭлементРасшифровкиКомпоновкиДанныхПоля - элемент для которого необходимо получить поля.
// СтруктураЗначений  - Тип Структура - Входной-выходной параметр содержит ключи (дополнительные параметры) необходимые
//                      для формирования отчета расшифровки.
//                     По наименованию поля ПолеЗначение.Поле, в НаборДанных выполняется поиск
//                     доступного поля, в свойстве "Текст" которого находится служебная информация о показателе.
// ДанныеРасшифровкиИзХранилища - Тип ДанныеРасшифровкиКомпоновкиДанных, используется для получения элемента
//                                расшифровки.
// НаборДанных        - Тип Набор данных схемы компоновки данных, используется для получения дополнительной технической
//                      информации из свойства "Текст" доступного поля компоновки данных.
//
&НаСервере
Процедура ПолучитьПоляРасшифровки(ЭлементРасшифровки, СтруктураЗначений, ДанныеРасшифровкиИзХранилища, НаборДанных)
	
	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ПолеЗначение Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			СтруктураЗначений.Вставить(ПолеЗначение.Поле, ПолеЗначение.Значение);
			Если СтруктураЗначений.ИмяГруппировкаОтчета = Неопределено Тогда
				Если Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.Элементы.Найти(ПолеЗначение.Поле) <> Неопределено Тогда
					СтруктураЗначений.ИмяГруппировкаОтчета = ПолеЗначение.Поле;
				КонецЕсли;
			КонецЕсли;
			Если СтруктураЗначений.ИмяПоказательОтчета = Неопределено Тогда
				ПолеОтчета = Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы.Найти(ПолеЗначение.Поле);
				Если ПолеОтчета <> Неопределено И ПолеОтчета.Ресурс Тогда
					СтруктураЗначений.ИмяПоказательОтчета = ПолеЗначение.Поле;
					ПолеСКД = НаборДанных.Поля.Найти("Расшифровка" + ПолеЗначение.Поле);
					ПолеСКД = ?(ПолеСКД = Неопределено, НаборДанных.Поля.Найти("Динамика" + ПолеЗначение.Поле), ПолеСКД);
					Если ПолеСКД <> Неопределено Тогда
						ПолеСКДПараметр = ПолеСКД.Оформление.Элементы.Найти("Текст");
						Если ПолеСКДПараметр <> Неопределено И НЕ ПустаяСтрока(ПолеСКДПараметр.Значение) Тогда
							СтрокаПараметров = СтрЗаменить(ПолеСКДПараметр.Значение, ",", Символы.ПС);
							// ПоказательБудетРасшифровывается, ВыводитьДинамику, ВыводитьИнтервалы, ИмяОтчета, Наименование показателя.
							СтруктураЗначений.ПоказательБудетРасшифровывается = Булево(СтрПолучитьСтроку(СтрокаПараметров, 1.00));
							СтруктураЗначений.ВыводитьДинамику = Булево(СтрПолучитьСтроку(СтрокаПараметров, 2.00));
							СтруктураЗначений.ВыводитьИнтервалы = Булево(СтрПолучитьСтроку(СтрокаПараметров, 3.00));
							СтруктураЗначений.ИмяОтчета = СтрПолучитьСтроку(СтрокаПараметров, 4.00);
							// Альтернативное название показателя - СтрПолучитьСтроку(СтрокаПараметров, 5.00);
							СтруктураЗначений.НаименованиеПоказателя = ПолеСКД.Заголовок;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если ПолеЗначение.Иерархия = Истина Тогда
				СтруктураЗначений.ИерархическийРесурс = Истина;
			КонецЕсли;
			Для Каждого ПоляРодители Из ЭлементРасшифровки.ПолучитьРодителей() Цикл
				ЭлементРасшифровки = ДанныеРасшифровкиИзХранилища.Элементы.Получить(ПоляРодители.Идентификатор);
				ПолучитьПоляРасшифровки(ЭлементРасшифровки, СтруктураЗначений, ДанныеРасшифровкиИзХранилища, НаборДанных);
			КонецЦикла;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхГруппировка") Тогда
		СтруктураЗначений.Вставить(ЭлементРасшифровки.Группировка);
		Для Каждого ПолеЗначение Из ЭлементРасшифровки.ПолучитьРодителей() Цикл
			ПолучитьПоляРасшифровки(ПолеЗначение, СтруктураЗначений, ДанныеРасшифровкиИзХранилища, НаборДанных);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Получает значение поля расшифровки.
//
&НаСервере
Функция ПолучитьЗначениеПоляРасшифровки(Расшифровка)
	
	СтруктураЗначений = Новый Структура();
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	СКД = ОтчетОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	// Значения по умолчанию
	СтруктураЗначений.Вставить("ИерархическийРесурс", Ложь);
	СтруктураЗначений.Вставить("ИмяГруппировкаОтчета", Неопределено);
	СтруктураЗначений.Вставить("ИмяПоказательОтчета", Неопределено);
	СтруктураЗначений.Вставить("ПоказательБудетРасшифровывается", Ложь);
	СтруктураЗначений.Вставить("ВыводитьДинамику", Ложь);
	СтруктураЗначений.Вставить("ВыводитьИнтервалы", Ложь);
	СтруктураЗначений.Вставить("ИмяОтчета", "");
	СтруктураЗначений.Вставить("НаименованиеПоказателя", "НаименованиеПоказателя");
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресХранилищаСКД);
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, ИсточникНастроек);
	ДанныеРасшифровкиИзХранилища = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	
	// Создадим и инициализируем обработчик расшифровки.
	СтруктураРасшифровки = Новый Структура;
	МассивПолейРасшифровки = Новый Массив();
	
	ЭлементРасшифровки = ДанныеРасшифровкиИзХранилища.Элементы.Получить(Расшифровка);
	НаборДанных = СКД.НаборыДанных.Найти("НаборДанныхОсновнойОтчет");
	ПолучитьПоляРасшифровки(ЭлементРасшифровки, СтруктураЗначений, ДанныеРасшифровкиИзХранилища, НаборДанных);
	СтруктураЗначений.ПоказательБудетРасшифровывается = ?(СтруктураЗначений.ИмяГруппировкаОтчета = Неопределено ИЛИ СтруктураЗначений.ИмяПоказательОтчета = Неопределено, Ложь, СтруктураЗначений.ПоказательБудетРасшифровывается);
	Возврат СтруктураЗначений;
	
КонецФункции

// Процедура обрабатывает формирование отчета расшифровки.
// Параметры:
//        СтруктураЗначений - Тип структура, Параметр используется как входной - выходной параметры,
//                              на выходе из алгоритма в структуру добавляется сформированный табличный документ
//                              для отображения его в клиентской процедуре.
//                              На входе алгоритма структура содержит параметры необходимые для формирования отчета
//                              расшифровки.
//
&НаСервере
Процедура СформироватьРасшифровкуНаСервере(СтруктураЗначений)
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	СКД = ОтчетОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	// Программное формирование структуры отчета для расшифровки.

	СтрокаУсловияОтчета = СтруктураЗначений.ИмяОтчета;
	ЗаголовокПоказателя = СтруктураЗначений.НаименованиеПоказателя;
	ИерархическийРесурс = СтруктураЗначений.ИерархическийРесурс;
	
	КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных();
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД));
	
	ПараметрВывода = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьПараметрыДанных"));
	ПараметрВывода.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
	ПараметрВывода.Использование = Истина;
	
	ПараметрВывода = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьОтбор"));
	ПараметрВывода.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
	ПараметрВывода.Использование = Истина;
	
	ПараметрВывода = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьЗаголовок"));
	ПараметрВывода.Значение = ТипВыводаТекстаКомпоновкиДанных.Выводить;
	ПараметрВывода.Использование = Истина;
	
	ПараметрВывода = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок"));
	ПараметрВывода.Значение = ЗаголовокПоказателя;
	ПараметрВывода.Использование = Истина;

	Если СтруктураЗначений.Расшифровка = "РасшифровкаПериоды" Тогда
		НаименованиеПоляГруппировки = СтруктураЗначений.ИмяГруппировкаОтчета;
		ЗначениеОтбора = СтруктураЗначений[СтруктураЗначений.ИмяГруппировкаОтчета];
		НаименованиеПоляПоказателя = "Расшифровка" + СтруктураЗначений.ИмяПоказательОтчета;
		
		ЭлементПорядкаКомпоновкиДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЭлементПорядкаКомпоновкиДанных.Поле = Новый ПолеКомпоновкиДанных("ПериодРасшифровка");
		ЭлементПорядкаКомпоновкиДанных.Использование = Истина;
		ЭлементПорядкаКомпоновкиДанных.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		
		ВыбранноеПолеКомпоновкиДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеКомпоновкиДанных.Поле = Новый ПолеКомпоновкиДанных(НаименованиеПоляПоказателя);
		ВыбранноеПолеКомпоновкиДанных.Использование = Истина;
		
		ДиаграммаКомпоновкиДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Структура.Добавить(Тип("ДиаграммаКомпоновкиДанных"));
		ВыбранноеПолеКомпоновкиДанных = ДиаграммаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеКомпоновкиДанных.Использование = Истина;
		
		ПараметрВыводаТипДиаграммы = ДиаграммаКомпоновкиДанных.ПараметрыВывода.Элементы.Найти("ТипДиаграммы");
		ПараметрВыводаТипДиаграммы.Значение = ТипДиаграммы.ГистограммаОбъемная;
		ПараметрВыводаТипДиаграммы.Использование = Истина;
		ВидПодписей = ПараметрВыводаТипДиаграммы.ЗначенияВложенныхПараметров.Найти("ТипДиаграммы.ВидПодписей");
		ВидПодписей.Значение = ВидПодписейКДиаграмме.Значение;
		ВидПодписей.Использование = Истина;
		
		ТочкаДиаграммы = ДиаграммаКомпоновкиДанных.Точки.Добавить();
		ВыбранноеПоле = ТочкаДиаграммы.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Использование = Истина;
		
		Если ИерархическийРесурс Тогда
			ЭлементОтбораКомпоновкиДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораКомпоновкиДанных.Использование = Истина;
			ЭлементОтбораКомпоновкиДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			// Условный программный выбор
			ЭлементОтбораКомпоновкиДанных.ЛевоеЗначение = КомпоновщикНастроекКомпоновкиДанных.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(НаименованиеПоляГруппировки)).Поле;
			ЭлементОтбораКомпоновкиДанных.ПравоеЗначение = ЗначениеОтбора;
			
			ЭлементОтбораКомпоновкиДанных = ТочкаДиаграммы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораКомпоновкиДанных.Использование = Истина;
			ЭлементОтбораКомпоновкиДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораКомпоновкиДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СистемныеПоля.Уровень");
			ЭлементОтбораКомпоновкиДанных.ПравоеЗначение = 1.00;
			ЭлементОтбораКомпоновкиДанных.Применение = ТипПримененияОтбораКомпоновкиДанных.ТолькоИерархия;
		Иначе
			ЭлементОтбораКомпоновкиДанных = ТочкаДиаграммы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораКомпоновкиДанных.Использование = Истина;
			ЭлементОтбораКомпоновкиДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			// Условный программный выбор
			ЭлементОтбораКомпоновкиДанных.ЛевоеЗначение = КомпоновщикНастроекКомпоновкиДанных.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(НаименованиеПоляГруппировки)).Поле;
			ЭлементОтбораКомпоновкиДанных.ПравоеЗначение = ЗначениеОтбора;
		КонецЕсли;
		// Отборы на поле группировки
		// Условие отчета "СписаниеТоваров" или "ОстатокВДняхТорговли" или "Продажи" или "ЧекиККМ".
		ЭлементОтбораКомпоновкиДанных = ТочкаДиаграммы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораКомпоновкиДанных.Использование = Истина;
		ЭлементОтбораКомпоновкиДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		// Условный программный выбор
		ЭлементОтбораКомпоновкиДанных.ЛевоеЗначение = КомпоновщикНастроекКомпоновкиДанных.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных("ИдентификаторОтчета")).Поле;
		ЭлементОтбораКомпоновкиДанных.ПравоеЗначение = СтрокаУсловияОтчета;
		
		ПолеГруппировкиКомпоновкиДанных = ТочкаДиаграммы.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировкиКомпоновкиДанных.Использование = Истина;
		ПолеГруппировкиКомпоновкиДанных.Поле = КомпоновщикНастроекКомпоновкиДанных.Настройки.ДоступныеПоляГруппировок.НайтиПоле(Новый ПолеКомпоновкиДанных("ПериодРасшифровка")).Поле;
		Если ИерархическийРесурс Тогда
			ПолеГруппировкиКомпоновкиДанных.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
		КонецЕсли;
		УстановитьТипДополненияДляГруппировкиПериод(ПолеГруппировкиКомпоновкиДанных, СтруктураЗначений);
		
	ИначеЕсли СтруктураЗначений.Расшифровка = "РасшифровкаДинамика" Тогда
		ВыбранноеПолеКомпоновкиДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеКомпоновкиДанных.Поле = Новый ПолеКомпоновкиДанных(СтруктураЗначений.ИмяПоказательОтчета);
		ВыбранноеПолеКомпоновкиДанных.Использование = Истина;
		ВыбранноеПолеКомпоновкиДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеКомпоновкиДанных.Поле = Новый ПолеКомпоновкиДанных("Динамика" + СтруктураЗначений.ИмяПоказательОтчета);
		ВыбранноеПолеКомпоновкиДанных.Использование = Истина;
		
		ГруппировкаКомпоновкиДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ВертикальноеРасположениеОбщихИтогов = ГруппировкаКомпоновкиДанных.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВертикальноеРасположениеОбщихИтогов"));
		ВертикальноеРасположениеОбщихИтогов.Значение = РасположениеИтоговКомпоновкиДанных.Начало;
		ВертикальноеРасположениеОбщихИтогов.Использование = Истина;
		
		ЭлементУсловногоОформленияКомпоновкиДанных = ГруппировкаКомпоновкиДанных.УсловноеОформление.Элементы.Добавить();
		ВыделятьОтрицательные = ЭлементУсловногоОформленияКомпоновкиДанных.Оформление.Элементы.Найти("ВыделятьОтрицательные");
		ВыделятьОтрицательные.Значение = Истина;
		ВыделятьОтрицательные.Использование = Истина;
		
		ВыбранноеПолеКомпоновкиДанных = ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ПолеГруппировкиКомпоновкиДанных = ГруппировкаКомпоновкиДанных.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировкиКомпоновкиДанных.Использование = Истина;
		ПолеГруппировкиКомпоновкиДанных.Поле = Новый ПолеКомпоновкиДанных(СтруктураЗначений.ИмяГруппировкаОтчета);
		Если ИерархическийРесурс Тогда
			ПолеГруппировкиКомпоновкиДанных.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			
			ЭлементОтбораКомпоновкиДанных = ГруппировкаКомпоновкиДанных.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораКомпоновкиДанных.Использование = Истина;
			ЭлементОтбораКомпоновкиДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораКомпоновкиДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СистемныеПоля.Уровень");
			ЭлементОтбораКомпоновкиДанных.ПравоеЗначение = 1.00;
			ЭлементОтбораКомпоновкиДанных.Применение = ТипПримененияОтбораКомпоновкиДанных.ТолькоИерархия;
		КонецЕсли;
		
		ЭлементОтбораКомпоновкиДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораКомпоновкиДанных.Использование = Истина;
		ЭлементОтбораКомпоновкиДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораКомпоновкиДанных.ЛевоеЗначение = КомпоновщикНастроекКомпоновкиДанных.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных("ИдентификаторОтчета")).Поле;
		ЭлементОтбораКомпоновкиДанных.ПравоеЗначение = СтрокаУсловияОтчета;

		ЭлементОтбораКомпоновкиДанных = ГруппировкаКомпоновкиДанных.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораКомпоновкиДанных.Использование = Истина;
		ЭлементОтбораКомпоновкиДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораКомпоновкиДанных.ЛевоеЗначение = КомпоновщикНастроекКомпоновкиДанных.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных("ИдентификаторОтчета")).Поле;
		ЭлементОтбораКомпоновкиДанных.ПравоеЗначение = СтрокаУсловияОтчета;
		
		ПараметрВывода = ГруппировкаКомпоновкиДанных.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьОтбор"));
		ПараметрВывода.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
		ПараметрВывода.Использование = Истина;
		
	КонецЕсли;
	
	УстановитьПараметрыКомпоновщикуНастроекСервер(СтруктураЗначений, Истина, КомпоновщикНастроекКомпоновкиДанных);
	
	КомпоновщикНастроекКомпоновкиДанных.РазвернутьАвтоПоля();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, КомпоновщикНастроекКомпоновкиДанных.Настройки);
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ТабличныйДокумент = Новый ТабличныйДокумент();
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабличныйДокумент);
	
	// Основной цикл вывода отчета.
	ПроцессорВывода.НачатьВывод();
	Пока Истина Цикл
		// Получим следующий элемент результата компоновки.
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();
		Если ЭлементРезультата = Неопределено Тогда
			// Следующий элемент не получен - заканчиваем цикл вывода.
			Прервать;
		Иначе
			// Элемент получен - выведем его при помощи процессора вывода.
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		КонецЕсли;
	
	КонецЦикла;
	// Обозначим завершение вывода.
	ПроцессорВывода.ЗакончитьВывод();
	СтруктураЗначений.Вставить("ТабличныйДокумент", ТабличныйДокумент);
	
КонецПроцедуры


#КонецОбласти
