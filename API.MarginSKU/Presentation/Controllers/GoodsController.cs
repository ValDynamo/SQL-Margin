using API.MarginSKU.Application.Interfaces;
using API.MarginSKU.Application.Services;
using API.MarginSKU.Domain.Entities;
using API.MarginSKU.Infrastructure.Interfaces;
using API.MarginSKU.Presentation.Base;
using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace API.MarginSKU.Presentation.Controllers
{
    [ApiController, Route("api/[controller]")]
    public class GoodsController : BaseApiController
    {
        private readonly IGoodService _goodService;

        public GoodsController(IGoodService goodService)
        {
            _goodService = goodService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllAsync([FromQuery] string format = "json")
        {
            var goods = await _goodService.GetAllAsync();

            return FormatResponse(goods, format, '|', "goods");
        }
    }
}
