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
    public class CustomersController : BaseApiController
    {
        private readonly ICustomerService _customerService;

        public CustomersController(ICustomerService customerService)
        {
            _customerService = customerService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllAsync([FromQuery] string format = "json")
        {
            var margins = await _customerService.GetAllAsync();

            return FormatResponse(margins, format, '|', "margins");
        }
    }
}
