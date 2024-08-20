﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		"ИмяФайла, ИдентификаторАбонента, ИдентификаторДокументооборота, АдресЗапросаНаСертификат, АдресСертификата,"
		+ "АдресКорневогоСертификата, АдресОтветаСервиса, СостояниеОбработкиЗаявления,"
		+ "ДатаОбновленияСостояния, СостояниеОбработкиЗаявленияАктуально");
	
	Если Параметры.СостояниеЗаявления <> Перечисления.СостоянияЗаявленияНаВыпускСертификата.Исполнено Тогда
		Элементы.ДекорацияСертификаты.Видимость = Ложь;
		Элементы.ДекорацияИнформацияДляПоддержки.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В случае ошибки обратитесь в службу поддержки фирмы ""1С"", предоставив <a href = ""%1"">техническую информацию о возникшей проблеме</a>.'"),
			"ИнформацияДляПоддержки"));
	КонецЕсли;
	
	Если Не Параметры.СостояниеЗаявления = Перечисления.СостоянияЗаявленияНаВыпускСертификата.НеПодготовлено
		И Не Параметры.СостояниеЗаявления = Перечисления.СостоянияЗаявленияНаВыпускСертификата.Подготовлено Тогда
		ЗаявлениеОтправлено = Истина
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияСертификатыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлектроннаяПодписьСлужебныйКлиент.СохранитьСертификат(
		Неопределено,
		?(НавигационнаяСсылка = "Сертификат", АдресСертификата, АдресКорневогоСертификата),
		?(НавигационнаяСсылка = "Сертификат", ИмяФайла, НСтр("ru = 'Корневой сертификат'")));
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияДляПоддержкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗаявлениеОтправлено И Не СостояниеОбработкиЗаявленияАктуально Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Для сбора технической информации о возникшей проблеме обновите состояние заявления.'"));
		Возврат;
	КонецЕсли;
	
	Сведения = Новый Массив;
	
	Если ЗаявлениеОтправлено Тогда
		Сведения.Добавить(НСтр("ru = 'Идентификатор документооборота'")
			+ ": " + Строка(ИдентификаторДокументооборота));
		Сведения.Добавить(НСтр("ru = 'Состояние обработки заявления'")
			+ " (" + Формат(ДатаОбновленияСостояния, "ДЛФ=DT") + ")"
			+ ":" + Символы.ПС + СостояниеОбработкиЗаявления + Символы.ПС);
	Иначе
		Сведения.Добавить(НСтр("ru = 'Заявление не отправлено'")
			+ ":" + Символы.ПС + СостояниеОбработкиЗаявления + Символы.ПС);
	КонецЕсли;
	
	
	ОписаниеФайлов = ОписаниеФайлов(Сведения);
	ЭлектроннаяПодписьСлужебныйКлиент.СформироватьТехническуюИнформацию(СтрСоединить(Сведения, Символы.ПС),
		Неопределено, ОписаниеФайлов);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОписаниеФайлов(Сведения)
	
	Индекс = Сведения.Количество();
	
	ОписаниеФайлов= Новый Массив;
	ДобавитьОписаниеФайла(ОписаниеФайлов, Сведения, НСтр("ru = 'Запрос на сертификат'"), "p10", АдресЗапросаНаСертификат);
	ДобавитьОписаниеФайла(ОписаниеФайлов, Сведения, НСтр("ru = 'Ответ сервиса 1С:Подпись'"), "zip", АдресОтветаСервиса);
	ДобавитьОписаниеФайла(ОписаниеФайлов, Сведения, НСтр("ru = 'Полученный корневой сертификат'"), "cer", АдресКорневогоСертификата);
	ДобавитьОписаниеФайла(ОписаниеФайлов, Сведения, НСтр("ru = 'Полученный сертификат'"), "cer", АдресСертификата);
	
	Если ОписаниеФайлов.Количество() > 0 Тогда
		Сведения.Вставить(Индекс, НСтр("ru = 'Приложенные файлы:'"));
		Сведения.Добавить(Символы.ПС);
	КонецЕсли;
	Возврат ОписаниеФайлов;
	
КонецФункции

&НаСервере
Процедура ДобавитьОписаниеФайла(ОписаниеФайлов, Сведения, Описание, Расширение, АдресДанных)
	
	Если Не ЗначениеЗаполнено(АдресДанных) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайла = ЭлектроннаяПодписьСлужебныйКлиентСервер.ПодготовитьСтрокуДляИмениФайла(
		Описание) + "." + Расширение;
	Сведения.Добавить(ИмяФайла);
	ОписаниеФайлов.Добавить(Новый Структура("Имя, Данные", ИмяФайла, АдресДанных));
	
КонецПроцедуры

#КонецОбласти
