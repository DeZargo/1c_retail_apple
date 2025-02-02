﻿&НаКлиенте
Перем КэшированныеЗначения;

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоНаименованию(Результат, ДополнительныеПараметры) Экспорт
		
	Если Результат <> Неопределено Тогда
		Для Каждого ДанныеСтроки Из Результат.ЗначенияПоиска Цикл
			ЗаполнитьЗначенияСвойств(Объект.Остатки.Добавить(),ДанныеСтроки);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(ТекКод, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(ТекКод) Тогда
		СтруктураПараметровКлиента = ПолученМагнитныйКод(ТекКод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработатьДанныеПоКодуСервер(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолученМагнитныйКод(МагнитныйКод) Экспорт 
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученМагнитныйКод(МагнитныйКод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученШтрихкодИзСШК(Штрихкод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	Если СтрокаРезультата.Свойство("Карта") Тогда
		Если СтрокаРезультата.ЭтоРегистрационнаяКарта Тогда
			ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		Иначе
			ИдентификаторСтроки = ДобавитьНайденнуюКарту(СтрокаРезультата);
		КонецЕсли;
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ИдентификаторСтроки = ДобавитьНайденныеСерийныеНомера(СтрокаРезультата);
		
	Иначе // Номенклатура.
		
		ИдентификаторСтроки = ДобавитьНайденныеПозицииТоваров(СтрокаРезультата);
		
	КонецЕсли;

	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		СтруктураРезультат.Вставить("АктивизироватьСтроку", ИдентификаторСтроки);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
	Если НЕ ОткрытаБлокирующаяФорма Тогда
		ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьДанныеИзТСДСервер(СтруктураПараметров) Экспорт
	
	Результат = ПодключаемоеОборудованиеРТВызовСервера.ОбработатьДанныеПоДисконтнымКартамИзТСДСервер(ЭтотОбъект, СтруктураПараметров);
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ДобавитьНайденныеПозицииТоваров(СтрокаРезультата) Экспорт 
	
	ИдентификаторСтроки = Неопределено;
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Номенклатура", СтрокаРезультата.Номенклатура);
	СтруктураПоиска.Вставить("Характеристика", СтрокаРезультата.Характеристика);
	НайденныеСтроки = Объект.Остатки.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.Количество() > 0 Тогда
		ИдентификаторСтроки = НайденныеСтроки[0].ПолучитьИдентификатор();
	Иначе
		Если СтрокаРезультата.Свойство("Характеристика")
			И ЗначениеЗаполнено(СтрокаРезультата.Характеристика) Тогда
			ТекстПредупреждения = НСтр("ru = 'Номенклатура ""%1"" с характеристикой ""%2"" не найдена в табличной части ""Остатки""'");
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ТекстПредупреждения,
									СтрокаРезультата.Номенклатура,
									СтрокаРезультата.Характеристика);
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Номенклатура ""%1"" не найдена в табличной части ""Остатки""'");
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ТекстПредупреждения, СтрокаРезультата.Номенклатура);
		КонецЕсли;
		СтрокаРезультата.Вставить("ТекстПредупреждения", ТекстПредупреждения);
	КонецЕсли;
	
	Возврат ИдентификаторСтроки;
	
КонецФункции

&НаСервере
Функция ДобавитьНайденныеСерийныеНомера(СтруктураНомера) Экспорт
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТВызовСервера.ДобавитьНоменклатуруПоСерийномуНомеру(ЭтотОбъект, СтруктураНомера);
	Возврат ИдентификаторСтроки;
	
КонецФункции

&НаСервере
Функция ДобавитьНайденнуюКарту(СтрокаРезультата) Экспорт
	
	ИдентификаторСтроки = Неопределено;
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ДисконтнаяКарта", СтрокаРезультата.Карта);
	НайденныеСтроки = Объект.Остатки.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.Количество() > 0 Тогда
		ИдентификаторСтроки = НайденныеСтроки[0].ПолучитьИдентификатор();
	Иначе
		Если ИдентификаторСтроки = Неопределено Тогда
			Модифицированность = Истина;
			
			ТекущаяСтрока = Неопределено;
			ДобавлятьНовуюСтроку = Истина;
			Если Объект.Остатки.Количество() > 0
				И Элементы.Остатки.ТекущаяСтрока <> Неопределено Тогда
				ТекущаяСтрока = Объект.Остатки.НайтиПоИдентификатору(Элементы.Остатки.ТекущаяСтрока);
				Если ТекущаяСтрока <> Неопределено Тогда
					Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ДисконтнаяКарта) Тогда
						ДобавлятьНовуюСтроку = Ложь;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			Если ДобавлятьНовуюСтроку ИЛИ ТекущаяСтрока = Неопределено Тогда
				ТекущаяСтрока = Объект.Остатки.Добавить();
			КонецЕсли;
			ТекущаяСтрока.ДисконтнаяКарта = СтрокаРезультата.Карта;
			
			ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИдентификаторСтроки;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьСозданиеИВыборНовойХарактеристики(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Объект.Остатки.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторТекущейСтроки);
	ТекущаяСтрока.Характеристика = Результат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПодключаемоеОборудование
	МассивКомандПО = Новый Массив;
	МассивКомандПО.Добавить("ОстаткиЗагрузитьДанныеИзТСД");
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект, МассивКомандПО);
	// Конец ПодключаемоеОборудование
	
	ДополнительныеКолонкиНоменклатуры = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ДополнительнаяКолонкаПриОтображенииНоменклатуры");
	
	ОбщегоНазначенияРТ.ЗаполнитьШапкуДокумента(
		Объект,
		КартинкаСостоянияДокумента,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		РазрешеноПроведение);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Остатки);
	КонецЕсли;
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
	НастроитьФормуПоДополнительнымПравам();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Остатки);
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение);
		
   	// &ЗамерПроизводительности 
    ОценкаПроизводительностиРТКлиент.ЗакончитьЗамер(ПараметрыЗаписи.Замер);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Остатки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// &ЗамерПроизводительности 
	Замер = ОценкаПроизводительностиРТКлиент.НачатьЗамер(Ложь, 
	                                            "Документ.ВводОстатковПоНакопительнымСкидкам.ФормаДокумента.Запись",
                                                           Ложь);
	
	ПараметрыЗаписи.Вставить("Замер", Замер);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьКартинкуДляКомментария", 0.5, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОстатки

&НаКлиенте
Процедура ОстаткиНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Остатки.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьТипНоменклатуры");
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПересчитатьКоличество");
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Остатки,
		ТекущаяСтрока,
		СтруктураДействий,
		КэшированныеЗначения);
		
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьХарактеристикуНоменклатуры(
		ЭтотОбъект,
		Элемент,
		СтандартнаяОбработка,
		Элементы.Остатки.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.СоздатьХарактеристикуНоменклатуры(ЭтотОбъект, Элемент, СтандартнаяОбработка, Элементы.Остатки.ТекущиеДанные, "Остатки");
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиКоличествоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Остатки.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	
	СтруктураДействий.Вставить("ПересчитатьКоличество");
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Остатки,
		ТекущаяСтрока,
		СтруктураДействий,
		КэшированныеЗначения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЕстьКоличество", Ложь);
	ПодключаемоеОборудованиеРТКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоНаименованию(Команда)
	
	ПараметрыПоиска = Новый Структура;
	РаботаСПравиламиИменованияКлиент.ПоискПоНаименованию(ЭтаФорма,ПараметрыПоиска);
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФормуПоДополнительнымПравам()

	УправлениеПользователями.УстановитьТолькоПросмотрДляРеквизитовТабличнойЧасти(Элементы.Дата.ТолькоПросмотр, 
																				 ПланыВидовХарактеристик.ПраваПользователей.ИзменятьДату);

КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента)
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТКлиент.ЗавершитьОбработкуДанныхПоКодуКлиент(ЭтотОбъект, СтруктураПараметровКлиента, "Остатки");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьКартинкуДляКомментария()
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
КонецПроцедуры

#КонецОбласти
