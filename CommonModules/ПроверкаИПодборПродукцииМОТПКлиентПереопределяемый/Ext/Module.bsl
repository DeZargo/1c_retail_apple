﻿#Область СлужебныйПрограмныйИнтерфейс

#Область СерииНоменклатуры

// Добавляет специфичные параметры указания серий для товаров, указанных в форме.
//
// Параметры:
//  Форма - УправляемаяФорма - форма с товарами, для которой необходимо определить параметры указания серий.
//  ПараметрыУказанияСерий - Структура - дополняемые параметры указания серий.
Процедура ДополнитьПараметрыУказанияСерий(Форма, ПараметрыУказанияСерий) Экспорт
	
	ПроверкаИПодборПродукцииМОТПРТКлиент.ДополнитьПараметрыУказанияСерий(Форма, ПараметрыУказанияСерий);
	
КонецПроцедуры

// Заполняет структуру, массив которых в дальнейшем будет передан в процедуру генерации серий.
//
// Параметры:
//  ДанныеДляГенерацииСерии - Структура - Описание:
//   * Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура, для которой будет генерироваться серия.
//   * Серия        - ОпределяемыйТип.СерииНоменклатуры   - В данное значение будет записана сгенерированная серия.
//   * МРЦ          - Число - Максимальная розничная цена табачной продукции.
//   * ЕстьОшибка   - Булево - Будет установлено в Истина, если по каким то причинам серия сгенерирована не будет.
//   * ТекстОшибки  - Строка - причина, по которой серия не генерировалась.
Процедура ПолучитьДанныеДляГенерацииСерии(ДанныеДляГенерацииСерии) Экспорт
	
	ДанныеДляГенерацииСерии = ИнтеграцияМОТПРТКлиентСервер.СтруктураДанныхДляГенерацииСерии();
	
КонецПроцедуры

#КонецОбласти

// Выполняет специфичные действия перед открытием формы проверки и подбора табачной продукции в зависимости от точки вызова
//
// Параметры:
//  Форма - УправляемаяФорма       - форма из которой происходит открытие формы проверки и подбора
//  ПараметрыОткрытияФормыПроверки - Структура - параметры открытия формы проверки и подбора для формы-источника
//  ПараметрыФормыПроверки         - Структура - подготовленные параметры открытия формы проверки и подбора
//  Отказ                          - Булево    - отказ от открытия формы
//
Процедура ПередОткрытиемФормыПроверкиПодбора(Форма, ПараметрыОткрытияФормыПроверки, ПараметрыФормыПроверки, Отказ) Экспорт
	
	ПроверкаИПодборПродукцииМОТПРТКлиент.ПередОткрытиемФормыПроверкиПодбора(Форма, ПараметрыОткрытияФормыПроверки, ПараметрыФормыПроверки, Отказ);
	
КонецПроцедуры

#КонецОбласти

