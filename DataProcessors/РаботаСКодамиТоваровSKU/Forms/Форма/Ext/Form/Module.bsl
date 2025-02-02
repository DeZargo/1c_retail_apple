﻿
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
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
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученШтрихкодИзСШК(Штрихкод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиСертификатов(СтруктураРезультат, СтрокаРезультата);
		
	Иначе
		
		ИдентификаторСтроки = НайтиСтрокуВТаблице(СтрокаРезультата);
		Если ИдентификаторСтроки = Неопределено Тогда
			Если СтрокаРезультата.Свойство("Характеристика")
				И ЗначениеЗаполнено(СтрокаРезультата.Характеристика) Тогда
				ТекстПредупреждения = НСтр("ru = 'Номенклатура ""%1"" с характеристикой ""%2"" не найдена в табличной части ""Товары""'");
				ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										ТекстПредупреждения,
										СтрокаРезультата.Номенклатура,
										СтрокаРезультата.Характеристика);
			Иначе
				ТекстПредупреждения = НСтр("ru = 'Номенклатура ""%1"" не найдена в табличной части ""Товары""'");
				ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										ТекстПредупреждения, СтрокаРезультата.Номенклатура);
			КонецЕсли;
			СтруктураРезультат.Вставить("ТекстПредупреждения", ТекстПредупреждения);
		КонецЕсли;
		
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

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Режим = "ОчисткаSKU";
	УстановитьРежим();
	ЗагрузитьНастройкиОтбора();
	
	НижняяГраницаДиапазонаSKUВесовогоТовара  = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("НижняяГраницаДиапазонаSKUВесовогоТовара");
	ВерхняяГраницаДиапазонаSKUВесовогоТовара = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ВерхняяГраницаДиапазонаSKUВесовогоТовара");
	
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	ИспользоватьУпаковкиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	
	Элементы.ТоварыХарактеристика.Видимость =  ИспользоватьХарактеристикиНоменклатуры;
	Элементы.ТоварыУпаковка.Видимость       =  ИспользоватьУпаковкиНоменклатуры;
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	РежимНастроек = Настройки.Получить("Режим");
	
	Если НЕ ПустаяСтрока(РежимНастроек) Тогда
		Режим = РежимНастроек;
	КонецЕсли;
	
	Если ПустаяСтрока(Режим) Тогда
		Режим = "ОчисткаSKU";
		Настройки["Режим"] = Режим;
	КонецЕсли;
	
	УстановитьРежим();
	ЗагрузитьНастройкиОтбора();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	Если НЕ ПодключаемоеОборудованиеOfflineВызовСервера.ДоступностьРаботыСКодамиТоваровSKU() Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Создание и удаление SKU осуществляется в главном узле РИБ'"));
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПриИзменении(Элемент)
	
	УстановитьРежим();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанныеВТСД(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("АдресТоваровВХранилище", ПоместитьВоВременноеХранилищеСервер());
	ДополнительныеПараметры.Вставить("ЭтоСсылочныйОбъект", Ложь);
	ПодключаемоеОборудованиеРТКлиент.ВыгрузитьДокументВТСД(ЭтотОбъект, Ложь, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ЗаполнитьИсправитьОчиститьSKU(Команда)
	
	ЕстьОшибки = Ложь;
	Если Объект.Товары.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Таблица ""Товары"" не заполнена'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"Объект.Товары",,ЕстьОшибки);
		
	КонецЕсли;
	
	Если ЕстьОшибки Тогда 
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(
			НСтр("ru='Изменение кодов SKU:'"),
			,
			НСтр("ru='Начато изменение кодов SKU.'"),
			БиблиотекаКартинок.Информация32);
			
	SKUИзменены = ИзменитьКодыSKU();
	
	ЗаполнитьТаблицуТоваровСервер();
	
	Если SKUИзменены Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru='Изменение кодов SKU:'"),
			,
			НСтр("ru='Коды SKU успешно изменены.'"),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	
	УстановитьСнятьФлажки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	
	УстановитьСнятьФлажки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуТоваров(Команда)
	
	Состояние(НСтр("ru = 'Выполняется обновление данных...'"));
	
	ЗаполнитьТаблицуТоваровСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьОтбора(Команда)
	
	ВидимостьОтбора = НЕ ВидимостьОтбора;
	
	Элементы.ОтборСтрокой.Видимость = НЕ ВидимостьОтбора;
	Элементы.ГруппаОтборТаблицей.Видимость = ВидимостьОтбора;
	
	Элементы.ФормаИзменитьВидимостьОтбора.Заголовок = ?(ВидимостьОтбора, НСтр("ru = 'Скрыть отбор'"), НСтр("ru = 'Показать отбор'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьSKU(Команда)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
        
        // &ЗамерПроизводительности
        ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "РегистрСведений.КодыТоваровSKU.Форма.ФормаЗаписи.Открытие");

		ПараметрыФормы = Новый Структура;
		
		Если ЗначениеЗаполнено(ТекущиеДанные.SKU) Тогда
			
			КлючЗаписи = СоздатьКлючЗаписиРегистра(ТекущиеДанные.SKU);
			ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
			
		Иначе
			
			ПараметрыСозданияSKU = Новый Структура;
			ПараметрыСозданияSKU.Вставить("Номенклатура",   ТекущиеДанные.Номенклатура);
			ПараметрыСозданияSKU.Вставить("Характеристика", ТекущиеДанные.Характеристика);
			ПараметрыСозданияSKU.Вставить("Упаковка",       ТекущиеДанные.Упаковка);
			
			ПараметрыФормы.Вставить("ПараметрыСозданияSKU", ПараметрыСозданияSKU);
			
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
		ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьSKUЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("РегистрСведений.КодыТоваровSKU.ФормаЗаписи", ПараметрыФормы,,,,,ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьSKUЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		ТекущаяСтрока.SKU = Результат.КодТовараSKU;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьКлючЗаписиРегистра(SKU)
	
	Возврат РегистрыСведений.КодыТоваровSKU.СоздатьКлючЗаписи(Новый Структура("SKU", SKU));
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоваровСервер()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
		
	ОбязательныеПоля = Новый Массив;
	ОбязательныеПоля.Добавить("SKU");
	ОбязательныеПоля.Добавить("Номенклатура");
	ОбязательныеПоля.Добавить("Выбран");
	
	Если ИспользоватьХарактеристикиНоменклатуры Тогда
		ОбязательныеПоля.Добавить("Характеристика");
	КонецЕсли;
	Если ИспользоватьУпаковкиНоменклатуры Тогда
		ОбязательныеПоля.Добавить("Упаковка");
	КонецЕсли;
	
	ПараметрыДанных = Новый Структура;   
	ПараметрыДанных.Вставить("ВерхняяГраницаДиапазонаSKUВесовогоТовара", ВерхняяГраницаДиапазонаSKUВесовогоТовара);
	ПараметрыДанных.Вставить("НижняяГраницаДиапазонаSKUВесовогоТовара",  НижняяГраницаДиапазонаSKUВесовогоТовара);
				
	Объект.Товары.Очистить();
		
	ТаблицаТоваров = ПодготовитьСтруктуруДанных(ОбязательныеПоля, ПараметрыДанных);
	
	Для Каждого СтрокаТЧ Из ТаблицаТоваров Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.Номенклатура = СтрокаТЧ.Номенклатура;
		НоваяСтрока.SKU          = СтрокаТЧ.SKU;
		НоваяСтрока.Весовой      = СтрокаТЧ.Весовой;
		НоваяСтрока.ОшибкаУпаковки       = СтрокаТЧ.ОшибкаУпаковки;
		НоваяСтрока.ОшибкаХарактеристики = СтрокаТЧ.ОшибкаХарактеристики;
		НоваяСтрока.ОшибкаДиапазона      = СтрокаТЧ.ОшибкаДиапазона;
		НоваяСтрока.Группа               = СтрокаТЧ.Группа;
		НоваяСтрока.ИндексКартинки       = 3;
		НоваяСтрока.SKUГруппыИнфо        = СтрокаТЧ.SKUГруппыИнфо;
		
		Если ИспользоватьХарактеристикиНоменклатуры Тогда
			НоваяСтрока.Характеристика = СтрокаТЧ.Характеристика;
		КонецЕсли;
		Если ИспользоватьУпаковкиНоменклатуры Тогда
			НоваяСтрока.Упаковка = СтрокаТЧ.Упаковка;
		КонецЕсли;
		
		Если Режим = "ЗаполнениеSKU" Тогда  
			НоваяСтрока.Выбран = (ПустаяСтрока(НоваяСтрока.SKU) ИЛИ НоваяСтрока.SKU = 0);
		Иначе
			НоваяСтрока.Выбран = НЕ (ПустаяСтрока(НоваяСтрока.SKU) ИЛИ НоваяСтрока.SKU = 0);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИспользоватьГруппыТоваров Тогда
		ТаблицаГрупп = Новый ТаблицаЗначений;
		ТаблицаГрупп.Колонки.Добавить("Номенклатура",       Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		ТаблицаГрупп.Колонки.Добавить("SKU",                Новый ОписаниеТипов("Число"));
		ТаблицаГрупп.Колонки.Добавить("SKUГруппы",          Новый ОписаниеТипов("Число"));
		ТаблицаГрупп.Колонки.Добавить("SKUГруппыИнфо",      Новый ОписаниеТипов("Число"));
		ТаблицаГрупп.Колонки.Добавить("ИндексКартинки",     Новый ОписаниеТипов("Число"));
		ТаблицаГрупп.Колонки.Добавить("Группа",             Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		ТаблицаГрупп.Колонки.Добавить("ЭтоГруппа",          Новый ОписаниеТипов("Булево"));
		
		МассивНоменклатур = ТаблицаТоваров.ВыгрузитьКолонку("Номенклатура");
		ДобавитьГруппыНоменклатуры(МассивНоменклатур, ТаблицаГрупп);
		
		ТаблицаГрупп.Свернуть("Номенклатура, SKU, SKUГруппы, SKUГруппыИнфо, ИндексКартинки, Группа, ЭтоГруппа");
		
		Для каждого Группа Из ТаблицаГрупп Цикл
			
			СтрокаТоваров = Объект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТоваров, Группа);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.Товары.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьГруппыНоменклатуры(МассивНоменклатур, ТаблицаГрупп)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СпрНоменклатура.Родитель КАК Номенклатура,
	|	МАКСИМУМ(КодыТоваровSKU.SKU) КАК SKU,
	|	КодыТоваровSKU.УдалитьSKUГруппы,
	|	КодыТоваровSKUГруппы.SKU КАК SKUГруппыИнфо,
	|	СпрНоменклатура.Родитель.Родитель КАК Группа
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|		ПО СпрНоменклатура.Родитель = КодыТоваровSKU.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKUГруппы
	|		ПО СпрНоменклатура.Родитель.Родитель = КодыТоваровSKUГруппы.Номенклатура
	|ГДЕ
	|	СпрНоменклатура.Ссылка В(&МассивНоменклатур)
	|	И НЕ СпрНоменклатура.Родитель = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпрНоменклатура.Родитель,
	|	КодыТоваровSKU.УдалитьSKUГруппы,
	|	КодыТоваровSKUГруппы.SKU,
	|	СпрНоменклатура.Родитель.Родитель";
	
	Запрос.УстановитьПараметр("МассивНоменклатур", МассивНоменклатур);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Отбор = Новый Структура("Номенклатура", Выборка.Номенклатура);
			НайденныеСтроки = ТаблицаГрупп.НайтиСтроки(Отбор);
			
			Если НайденныеСтроки.Количество() > 0 Тогда
				
				СтрокаТаблицы = НайденныеСтроки[0];
				ИндексСтроки = ТаблицаГрупп.Индекс(СтрокаТаблицы);
				
				ТаблицаГрупп.Сдвинуть(СтрокаТаблицы, ТаблицаГрупп.Количество()-1-ИндексСтроки);
			
			Иначе
				
				НоваяСтрока = ТаблицаГрупп.Добавить();
				НоваяСтрока.Номенклатура   = Выборка.Номенклатура;
				НоваяСтрока.SKU            = Выборка.SKU;
				НоваяСтрока.SKUГруппыИнфо  = Выборка.SKUГруппыИнфо;
				НоваяСтрока.ИндексКартинки = 0;
				НоваяСтрока.Группа         = Выборка.Группа;
				НоваяСтрока.ЭтоГруппа      = Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
		МассивНоменклатур = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Номенклатура");
		ДобавитьГруппыНоменклатуры(МассивНоменклатур, ТаблицаГрупп);
	КонецЕсли;
	
КонецПроцедуры

// Функция формирует таблицу товаров для дальнейшей обработки.
// Параметры: 
// ОбязательныеПоля - Массив - Массив имен обязательных полей.
// ПараметрыДанных - Структура - Структура с ключами - именами параметров СКД и значениями параметров в значениях
//                               структуры.
// Возвращаемое значение: 
// ТаблицаТоваров - ТаблицаЗначений
&НаСервере
Функция ПодготовитьСтруктуруДанных(ОбязательныеПоля, ПараметрыДанных)
	
	СхемаКомпоновкиДанных = Обработки.РаботаСКодамиТоваровSKU.ПолучитьМакет("СписокКодовSKU");
	
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Компоновщик.Настройки.Отбор.Элементы.Очистить();
	// Удаление отборов содержащие ошибки.
	Количество = КомпоновщикНастроек.Настройки.Отбор.Элементы.Количество();
	Для Индекс = 1 По Количество Цикл
		ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы[Количество - Индекс];
		ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
		Если КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
			КомпоновщикНастроек.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
	Если КомпоновщикНастроек <> Неопределено Тогда
		ОбщегоНазначенияРТКлиентСервер.СкопироватьЭлементы(Компоновщик.Настройки.Отбор, КомпоновщикНастроек.Настройки.Отбор);
	КонецЕсли;
		
	Для Каждого ОбязательноеПоле Из ОбязательныеПоля Цикл
		ПолеСКД = КомпоновкаДанныхСервер.НайтиПолеСКДПоПолномуИмени(Компоновщик.Настройки.Выбор.ДоступныеПоляВыбора.Элементы, ОбязательноеПоле);
		Если ПолеСКД <> Неопределено Тогда
			ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле = ПолеСКД.Поле;
		КонецЕсли;
	КонецЦикла;
	
	// Компоновка макета компоновки данных.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Компоновщик.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	Параметр = МакетКомпоновкиДанных.ЗначенияПараметров.Найти("ВерхняяГраницаДиапазонаSKUВесовогоТовара");
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = ВерхняяГраницаДиапазонаSKUВесовогоТовара;
	КонецЕсли;
	
	Параметр = МакетКомпоновкиДанных.ЗначенияПараметров.Найти("НижняяГраницаДиапазонаSKUВесовогоТовара");
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = НижняяГраницаДиапазонаSKUВесовогоТовара;
	КонецЕсли;

	Запрос = Новый Запрос(МакетКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос);
	
	// Заполнение параметров с полей отбора компоновщика настроек формы обработки.
	Для каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		Запрос.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
	КонецЦикла;       
					
	ТаблицаТоваров = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаТоваров;

КонецФункции

&НаСервере
Процедура УстановитьРежим()
	
	Если Режим = "ОчисткаSKU" Тогда
		
		Элементы.ЗаполнитьИсправитьОчиститьSKU.Заголовок = НСтр("ru = 'Очистить SKU'");
		
	ИначеЕсли Режим = "ЗаполнениеSKU" Тогда
		
		Элементы.ЗаполнитьИсправитьОчиститьSKU.Заголовок = НСтр("ru = 'Сгенерировать SKU'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИзменитьКодыSKU()

	SKUИзменены     = Истина;
	ЗакончилисьSKU = Ложь;
		
	Попытка
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Изменение кодов SKU'", "ru"), УровеньЖурналаРегистрации.Информация, , ,НСтр("ru = 'Начато действие'"));
		
		Если Режим = "ЗаполнениеSKU" Тогда 
			
			НачатьТранзакцию();
			ТаблицаТоваров = Объект.Товары.Выгрузить();
			СоздаватьSKU = Истина;
			РегистрыСведений.КодыТоваровSKU.ОбновитьКоды_SKU_PLU(ТаблицаТоваров, СоздаватьSKU,,ЗакончилисьSKU);
			
		ИначеЕсли Режим = "ОчисткаSKU" Тогда
			
			РазмерПорцииТранзакции = 1000;
			СчетчикТранзакций = 0;
			
			НачатьТранзакцию();
			
			Для Каждого СтрокаТЧ Из Объект.Товары Цикл
				
				Если СтрокаТЧ.Выбран Тогда
					РегистрыСведений.КодыТоваровSKU.УдалитьSKU(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика, СтрокаТЧ.Упаковка, СтрокаТЧ.SKU);
					
					СчетчикТранзакций = СчетчикТранзакций + 1;
					Если СчетчикТранзакций >= РазмерПорцииТранзакции Тогда
						
						СчетчикТранзакций = 0;
						ЗафиксироватьТранзакцию();
						
						НачатьТранзакцию();
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ЗакончилисьSKU Тогда
			
			ТекстСообщения = НСтр("ru = 'В процессе заполнения закончились доступные SKU коды товара. Операция завершена не полностью.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Товары");
			
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Изменение кодов SKU'", "ru"), УровеньЖурналаРегистрации.Информация, , ,НСтр("ru = 'Действие завершено'"));
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстСообщения = ОписаниеОшибки();
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Товары");
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Изменение кодов SKU'", "ru"), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		SKUИзменены = Ложь;
		
	КонецПопытки;
	
	Возврат SKUИзменены;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьНастройкиОтбора()
	
	СхемаКомпоновкиДанных = Обработки.РаботаСКодамиТоваровSKU.ПолучитьМакет("СписокКодовSKU");
	
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор)));
		
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСнятьФлажки(Пометка)
	
	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		СтрокаТЧ.Выбран = Пометка;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция НайтиСтрокуВТаблице(СтруктураРезультат)
	
	ИдентификаторСтроки = Неопределено;
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Номенклатура", СтруктураРезультат.Номенклатура);
	Если СтруктураРезультат.Свойство("Характеристика") Тогда
		СтруктураПоиска.Вставить("Характеристика", СтруктураРезультат.Характеристика);
	КонецЕсли;
	СтрокиТаблицы = Объект.Товары.НайтиСтроки(СтруктураПоиска);
	Если СтрокиТаблицы.Количество() > 0 Тогда
		ИдентификаторСтроки = СтрокиТаблицы[0].ПолучитьИдентификатор();
	КонецЕсли;
		
	
	Возврат ИдентификаторСтроки;
	
КонецФункции

&НаКлиенте
Процедура ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметров)
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТКлиент.ЗавершитьОбработкуДанныхПоКодуКлиент(ЭтотОбъект, СтруктураПараметров);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеСервер()
	
	ТоварыДляВыгрузки = Объект.Товары.Выгрузить();
	АдресВХранилище = ПоместитьВоВременноеХранилище(ТоварыДляВыгрузки, УникальныйИдентификатор);
	Возврат АдресВХранилище;
	
КонецФункции

#КонецОбласти