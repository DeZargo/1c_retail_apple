﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с номенклатурой".
// ОбщийМодуль.РаботаСНоменклатуройКлиентПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ФормаПоискНоменклатурыПоШтрихкоду

// Процедура, вызываемая из обработчика события формы ПриОткрытии формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - УправляемаяФорма - форма из обработчика события которой происходит вызов процедуры.
//
Процедура ПоискНоменклатурыПоШтрихкодуПриОткрытии(Форма) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ПоискНоменклатурыПоШтрихкодуПриОткрытии(Форма);
	
КонецПроцедуры

// Процедура, вызываемая из обработчика события формы ПриЗакрытии формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - УправляемаяФорма - форма из обработчика события которой происходит вызов процедуры.
//  ЗавершениеРаботы - Булево - признак завершения работы.
//
Процедура ПоискНоменклатурыПоШтрихкодуПриЗакрытии(Форма, ЗавершениеРаботы) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ПоискНоменклатурыПоШтрихкодуПриЗакрытии(Форма, ЗавершениеРаботы);
	
КонецПроцедуры

// Процедура, вызываемая из обработчика оповещения формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - УправляемаяФорма - форма из обработчика события которой происходит вызов процедуры.
//  ИмяСобытия	 - Строка - имя события.
//  Параметр	 - Любой - параметры оповещения.
//  Источник	 - Строка - источник оповещения.
//  ШтрихКоды	 - Массив - массив строк штрихкодов. Заполняется при отработке оповещений от оборудования (Строка).
//
Процедура ПоискНоменклатурыПоШтрихкодуОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ШтрихКоды) Экспорт
		
КонецПроцедуры

// Процедура, вызываемая при обработке выбора формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - УправляемаяФорма - форма из обработчика события которой происходит вызов процедуры.
//  ВыбранноеЗначение - Любой - выбранное значение.
//  ИсточникВыбора - Любой - источник выбора.
//
Процедура ПоискНоменклатурыПоШтрихкодуОбработкаВыбора(Форма, ВыбранноеЗначение, ИсточникВыбора) Экспорт
		
КонецПроцедуры

// Процедура, вызываемая при изменении поля Номенклатура формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма	 - УправляемаяФорма - форма поиска номенклатуры по штрихкоду.
//  Элемент	 - ПолеФормы - изменяемое поле формы.
//
Процедура ПоискНоменклатурыПоШтрихкодуНоменклатураПриИзменении(Форма, Элемент) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ПоискНоменклатурыПоШтрихкодуНоменклатураПриИзменении(Форма, Элемент);
	
КонецПроцедуры

// Процедура, вызываемая при создании в поле Номенклатура формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - УправляемаяФорма - форма из обработчика события которой происходит вызов процедуры.
//  Элемент				 - ПолеФормы - элемент формы.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ПоискНоменклатурыПоШтрихкодуНоменклатураСоздание(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Процедура, вызываемая при начале выбора в поле Номенклатура формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - УправляемаяФорма - форма из обработчика события которой происходит вызов процедуры.
//  Элемент				 - ПолеФормы - элемент формы.
//  ДанныеВыбора		 - СписокЗначений - данные выбора..
//  СтандартнаяОбработка - Булево -  признак стандартной обработки.
//
Процедура ПоискНоменклатурыПоШтрихкодуНоменклатураНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Процедура, вызываемая при создании в поле Характеристика формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - УправляемаяФорма - форма из обработчика события которой происходит вызов процедуры.
//  Элемент				 - ПолеФормы - элемент формы.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ПоискНоменклатурыПоШтрихкодуХарактеристикаСоздание(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ПоискНоменклатурыПоШтрихкодуХарактеристикаСоздание(
		Форма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура, вызываемая при создании в поле Характеристика формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - УправляемаяФорма - форма из обработчика события которой происходит вызов процедуры.
//  Элемент				 - ПолеФормы - элемент формы.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ПоискНоменклатурыПоШтрихкодуХарактеристикаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ПоискНоменклатурыПоШтрихкодуХарактеристикаНачалоВыбора(
		Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

// Процедура открывает форму элемента номенклатуры в случает интерактивного заполнения.
//
// Параметры:
//  ПараметрыФормы				 - Структура		 - параметры, которые необходимо передать в форму элемента.
//  ОписаниеОповещенияОЗакрытии	 - ОписаниеОповещения	 - оповещение о закрытии формы. В обработчик должен передаваться
//                                                         параметр НоменклатураСсылка с ссылкой на элемент.
//
Процедура СоздатьНоменклатуруИнтерактивно(ПараметрыФормы, ОписаниеОповещенияОЗакрытии) Экспорт
	
	РаботаСНоменклатуройРТКлиент.СоздатьНоменклатуруИнтерактивно(
		ПараметрыФормы, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

// Процедура открывает форму элемента вида номенклатуры в случает интерактивного заполнения.
//  Режим открытия окна должен установлен в значение Независимый.
//
// Параметры:
//  ПараметрыФормы				 - Структура		 - параметры, которые необходимо передать в форму элемента.
//  ОписаниеОповещенияОЗакрытии	 - ОписаниеОповещения	 - оповещение о закрытии.
//
Процедура СоздатьВидНоменклатурыИнтерактивно(ПараметрыФормы, ОписаниеОповещенияОЗакрытии) Экспорт
	
	РаботаСНоменклатуройРТКлиент.СоздатьВидНоменклатурыИнтерактивно(
		ПараметрыФормы, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

// Открытие формы значения дополнительного реквизита.
//
// Параметры:
//  ПараметрыФормы - Структура - Ключи:
//                   * РеквизитСсылка - Ссылка - Ссылка на дополнительный реквизит.
//                   * Наименование   - Строка - Наименование значения дополнительного реквизита по умолчанию.
//  Форма          - УправляемаяФорма - Форма-владелец.
//
Процедура ОткрытьФормуДополнительногоЗначения(ПараметрыФормы, Форма) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ОткрытьФормуДополнительногоЗначения(
		ПараметрыФормы, Форма);
	
КонецПроцедуры

// Открытие формы дополнительного реквизита.
//
// Параметры:
//  ПараметрыФормы	 - Структура - параметры формы.
//  Владелец			 - УправляемаяФорма - форма владелец.
//
Процедура ОткрытьФормуДополнительногоРеквизита(ПараметрыФормы, Владелец) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ОткрытьФормуДополнительногоРеквизита(
		ПараметрыФормы, Владелец);
	
КонецПроцедуры

// Открытие формы номенклатуры.
//
// Параметры:
//  НоменклатураСсылка	 - Ссылка - ссылка на номенклатуру.
//  Владелец			 - УправляемаяФорма - форма владелец.
//
Процедура ОткрытьФормуНоменклатуры(НоменклатураСсылка, Владелец) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ОткрытьФормуНоменклатуры(
		НоменклатураСсылка, Владелец);
	
КонецПроцедуры

// Открытие формы вида номенклатуры.
//
// Параметры:
//  ВидНоменклатурыСсылка - Ссылка - ссылка на вид номенклатуры.
//  Владелец			 - УправляемаяФорма - форма владелец.
//
Процедура ОткрытьФормуВидаНоменклатуры(ВидНоменклатурыСсылка, Владелец) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ОткрытьФормуВидаНоменклатуры(
		ВидНоменклатурыСсылка, Владелец);
	
КонецПроцедуры

// Открытие формы списка вида номенклатуры.
//
// Параметры:
//  ВидНоменклатурыСсылка - Ссылка - ссылка на вид номенклатуры.
//  Владелец			 - УправляемаяФорма - форма владелец.
//
Процедура ОткрытьФормуСпискаВидаНоменклатуры(ВидНоменклатурыСсылка, Владелец) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ОткрытьФормуСпискаВидаНоменклатуры(
		ВидНоменклатурыСсылка, Владелец);
	
КонецПроцедуры

// Открытие формы списка номенклатуры.
//
// Параметры:
//  НоменклатураСсылка	 - Ссылка - ссылка на номенклатуру.
//  Владелец			 - УправляемаяФорма - форма владелец.
//
Процедура ОткрытьФормуСпискаНоменклатуры(НоменклатураСсылка, Владелец) Экспорт
	
	РаботаСНоменклатуройРТКлиент.ОткрытьФормуСпискаНоменклатуры(
		НоменклатураСсылка, Владелец);
	
КонецПроцедуры

#КонецОбласти
