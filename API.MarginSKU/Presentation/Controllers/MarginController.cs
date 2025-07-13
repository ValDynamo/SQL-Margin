using API.MarginSKU.Application.Interfaces;
using API.MarginSKU.Presentation.Base;
using Microsoft.AspNetCore.Mvc;

namespace API.MarginSKU.Presentation.Controllers
{
    [ApiController, Route("api/[controller]")]
    public class MarginController : BaseApiController
    {
        private readonly IMarginService _marginService;

        public MarginController(IMarginService marginService)
        {
            _marginService = marginService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllAsync(
            [FromQuery] DateTime? fromDate,
            [FromQuery] DateTime? toDate,
            [FromQuery] string format = "json")
        {
            if (!TryValidateDateRange(fromDate, toDate, out var error))
                return BadRequest(error);

            var margins = await _marginService.GetAllAsync(fromDate.Value, toDate.Value);

            return FormatResponse(margins, format, '|', "margins");
        }
    }
}
