using CsvHelper.Configuration;
using CsvHelper;
using Microsoft.AspNetCore.Mvc;
using System.Globalization;

namespace API.MarginSKU.Presentation.Base
{
    public abstract class BaseApiController : ControllerBase
    {
        protected IActionResult FormatResponse<T>(IEnumerable<T> data, string format, char delimiter = '|', string filePrefix = "export")
        {
            if (string.Equals(format, "csv", StringComparison.OrdinalIgnoreCase))
            {
                var csvBytes = SerializeToCsv(data, delimiter);
                var fileName = $"{filePrefix}_{DateTime.Now:yyyyMMddHHmmss}.csv";
                return File(csvBytes, "text/csv", fileName);
            }

            return Ok(data);
        }
        protected byte[] SerializeToCsv<T>(IEnumerable<T> records, char delimiter = '|')
        {
            using var memoryStream = new MemoryStream();
            using var streamWriter = new StreamWriter(memoryStream);

            var config = new CsvConfiguration(CultureInfo.InvariantCulture)
            {
                Delimiter = delimiter.ToString(),
                HasHeaderRecord = true,
            };

            using var csvWriter = new CsvWriter(streamWriter, config);
            csvWriter.WriteRecords(records);
            streamWriter.Flush();
            return memoryStream.ToArray();
        }
        protected bool TryValidateDateRange(
            DateTime? fromDate,
            DateTime? toDate,
            out string errorMessage)
        {
            errorMessage = null;

            if (!fromDate.HasValue || !toDate.HasValue)
            {
                errorMessage = "Parameters 'fromDate' and 'toDate' are required.";
                return false;
            }

            if (fromDate > toDate)
            {
                errorMessage = "'fromDate' must be less or equal to 'toDate'.";
                return false;
            }

            return true;
        }
    }
}
