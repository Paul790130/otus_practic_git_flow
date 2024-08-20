﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//  Структура:
//   * Ссылка - СправочникСсылка.НастройкиАвторизацииИнтернетСервисов
//   * ИмяИнтернетСервиса - Строка
//   * ВладелецДанных - Строка
//   * АдресАвторизации - Строка
//   * АдресРегистрацииУстройства - Строка
//   * АдресПолученияКлюча - Строка
//   * АдресПеренаправления - Строка
//   * ЗапрашиваемыеРазрешения - Строка
//   * ИспользоватьКлючПроверкиПодлинностиPKCE - Булево
//   * ИдентификаторПриложения - Строка
//   * ИспользоватьПарольПриложения - Булево
//   * ПарольПриложения - Строка
//   * ДополнительныеПараметрыАвторизации - Строка
//   * ДополнительныеПараметрыПолученияТокена - Строка
//   * ПояснениеПоАдресуПеренаправления - Строка
//   * ПояснениеПоИдентификаторуПриложения - Строка
//   * ПояснениеПоПаролюПриложения - Строка
//   * ДополнительноеПояснение - Строка
//   * ПсевдонимАдресаПеренаправления - Строка
//   * ПсевдонимИдентификатораПриложения - Строка
//   * ПсевдонимПароляПриложения - Строка
//   * АдресПеренаправленияПоУмолчанию - Строка
//   * АдресПеренаправленияВебКлиент - Строка
//
Функция НастройкиАвторизацииИнтернетСервиса(ИмяИнтернетСервиса, ВладелецДанных) Экспорт

	НастройкиАвторизации = Новый Структура;
	НастройкиАвторизации.Вставить("Ссылка");
	НастройкиАвторизации.Вставить("ИмяИнтернетСервиса");
	НастройкиАвторизации.Вставить("ВладелецДанных");
	НастройкиАвторизации.Вставить("АдресАвторизации");
	НастройкиАвторизации.Вставить("АдресРегистрацииУстройства");
	НастройкиАвторизации.Вставить("АдресПолученияКлюча");
	НастройкиАвторизации.Вставить("АдресПеренаправления");
	НастройкиАвторизации.Вставить("АдресПеренаправленияВебКлиент");
	НастройкиАвторизации.Вставить("ЗапрашиваемыеРазрешения");
	НастройкиАвторизации.Вставить("ИспользоватьКлючПроверкиПодлинностиPKCE");
	НастройкиАвторизации.Вставить("ИдентификаторПриложения");
	НастройкиАвторизации.Вставить("ИспользоватьПарольПриложения");
	НастройкиАвторизации.Вставить("ПарольПриложения");
	НастройкиАвторизации.Вставить("ДополнительныеПараметрыАвторизации");
	НастройкиАвторизации.Вставить("ДополнительныеПараметрыПолученияТокена");
	НастройкиАвторизации.Вставить("ПояснениеПоАдресуПеренаправления", "");
	НастройкиАвторизации.Вставить("ПояснениеПоИдентификаторуПриложения", "");
	НастройкиАвторизации.Вставить("ПояснениеПоПаролюПриложения", "");
	НастройкиАвторизации.Вставить("ДополнительноеПояснение", "");
	НастройкиАвторизации.Вставить("ПсевдонимАдресаПеренаправления", "");
	НастройкиАвторизации.Вставить("ПсевдонимИдентификатораПриложения", "");
	НастройкиАвторизации.Вставить("ПсевдонимПароляПриложения", "");
	НастройкиАвторизации.Вставить("АдресПеренаправленияПоУмолчанию", "");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкиАвторизацииИнтернетСервисов.Ссылка,
	|	НастройкиАвторизацииИнтернетСервисов.АдресАвторизации,
	|	НастройкиАвторизацииИнтернетСервисов.АдресПолученияКлюча,
	|	НастройкиАвторизацииИнтернетСервисов.АдресРегистрацииУстройства,
	|	НастройкиАвторизацииИнтернетСервисов.АдресПеренаправления,
	|	НастройкиАвторизацииИнтернетСервисов.АдресПеренаправленияВебКлиент,
	|	НастройкиАвторизацииИнтернетСервисов.ИспользоватьКлючПроверкиПодлинностиPKCE,
	|	НастройкиАвторизацииИнтернетСервисов.ИдентификаторПриложения,
	|	НастройкиАвторизацииИнтернетСервисов.ЗапрашиваемыеРазрешения,
	|	НастройкиАвторизацииИнтернетСервисов.ИспользоватьПарольПриложения,
	|	НастройкиАвторизацииИнтернетСервисов.ДополнительныеПараметрыАвторизации,
	|	НастройкиАвторизацииИнтернетСервисов.ДополнительныеПараметрыПолученияТокена,
	|	НастройкиАвторизацииИнтернетСервисов.ИмяИнтернетСервиса,
	|	НастройкиАвторизацииИнтернетСервисов.ВладелецДанных
	|ИЗ
	|	Справочник.НастройкиАвторизацииИнтернетСервисов КАК НастройкиАвторизацииИнтернетСервисов
	|ГДЕ
	|	НастройкиАвторизацииИнтернетСервисов.ВладелецДанных = &ВладелецДанных
	|	И НастройкиАвторизацииИнтернетСервисов.ИмяИнтернетСервиса = &ИмяИнтернетСервиса
	|	И НЕ НастройкиАвторизацииИнтернетСервисов.ПометкаУдаления";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ВладелецДанных", ВладелецДанных);
	Запрос.УстановитьПараметр("ИмяИнтернетСервиса", ИмяИнтернетСервиса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(НастройкиАвторизации, Выборка);
		НастройкиАвторизации.ПарольПриложения = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Выборка.Ссылка, "ПарольПриложения");
	КонецЕсли;
	
	Возврат НастройкиАвторизации;
	
КонецФункции

// Параметры:
//  НастройкиАвторизации - см. НастройкиАвторизацииИнтернетСервиса
//
Процедура ЗаписатьНастройкиАвторизации(НастройкиАвторизации) Экспорт
	
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Если ЗначениеЗаполнено(НастройкиАвторизации.Ссылка) Тогда
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.НастройкиАвторизацииИнтернетСервисов");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", НастройкиАвторизации.Ссылка);
			Блокировка.Заблокировать();
			
			НастройкиАвторизацииОбъект = НастройкиАвторизации.Ссылка.ПолучитьОбъект();
		Иначе
			НастройкиАвторизацииОбъект = СоздатьЭлемент();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НастройкиАвторизации.Ссылка) Тогда
			Для Каждого Элемент Из НастройкиАвторизации Цикл
				Если Элемент.Ключ = "Ссылка" Или Элемент.Ключ = "ПарольПриложения" Тогда
					Продолжить;
				КонецЕсли;
				
				ПроверяемоеСвойство = Новый Структура(Элемент.Ключ, null);
				ЗаполнитьЗначенияСвойств(ПроверяемоеСвойство, НастройкиАвторизацииОбъект);
				
				Если ПроверяемоеСвойство[Элемент.Ключ] <> null 
					И НастройкиАвторизацииОбъект[Элемент.Ключ] <> Элемент.Значение Тогда
						НастройкиАвторизацииОбъект[Элемент.Ключ] = Элемент.Значение;
				КонецЕсли;
			КонецЦикла;
		Иначе
			ЗаполнитьЗначенияСвойств(НастройкиАвторизацииОбъект, НастройкиАвторизации, , "Ссылка");
		КонецЕсли;
		
		Если НастройкиАвторизацииОбъект.Модифицированность() Тогда
			НастройкиАвторизацииОбъект.Записать();
		КонецЕсли;
		Если НастройкиАвторизации.ИспользоватьПарольПриложения Тогда
			ПарольПриложения = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(НастройкиАвторизацииОбъект.Ссылка, "ПарольПриложения");
			Если ПарольПриложения <> НастройкиАвторизации.ПарольПриложения Тогда
				ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(НастройкиАвторизацииОбъект.Ссылка, НастройкиАвторизации.ПарольПриложения, "ПарольПриложения");
			КонецЕсли;
		КонецЕсли;
	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция Разрешения()
	
	Результат = Новый Соответствие;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НастройкиАвторизацииИнтернетСервисов.Ссылка,
	|	НастройкиАвторизацииИнтернетСервисов.АдресАвторизации,
	|	НастройкиАвторизацииИнтернетСервисов.АдресПолученияКлюча,
	|	НастройкиАвторизацииИнтернетСервисов.АдресРегистрацииУстройства
	|ИЗ
	|	Справочник.НастройкиАвторизацииИнтернетСервисов КАК НастройкиАвторизацииИнтернетСервисов
	|ГДЕ
	|	НЕ НастройкиАвторизацииИнтернетСервисов.ПометкаУдаления";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Разрешения = Новый Массив;
		
		ДобавитьРазрешениеДляИнтернетРесурса(Разрешения, Выборка.АдресАвторизации);
		ДобавитьРазрешениеДляИнтернетРесурса(Разрешения, Выборка.АдресПолученияКлюча);
		ДобавитьРазрешениеДляИнтернетРесурса(Разрешения, Выборка.АдресРегистрацииУстройства);
				
		Результат.Вставить(Выборка.Ссылка, Разрешения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьРазрешениеДляИнтернетРесурса(Разрешения, АдресИнтернетРесурса)
	
	Если Не ЗначениеЗаполнено(АдресИнтернетРесурса) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресИнтернетРесурса);
	
	Если Не ЗначениеЗаполнено(СтруктураURI.Схема) Или Не ЗначениеЗаполнено(СтруктураURI.Хост) Тогда
		Возврат;
	КонецЕсли;
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	Разрешения.Добавить(
		МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			ВРег(СтруктураURI.Схема),
			СтруктураURI.Хост,
			,
			НСтр("ru = 'Электронная почта.'")));
	
КонецПроцедуры

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт

	Если ОбщегоНазначения.РазделениеВключено()
	   И Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Для Каждого ОписаниеРазрешений Из Разрешения() Цикл
		ЗапросыРазрешений.Добавить(МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(
			ОписаниеРазрешений.Значение, ОписаниеРазрешений.Ключ));
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли