using API.MarginSKU.Application.Interfaces;
using API.MarginSKU.Domain.Entities;
using API.MarginSKU.Infrastructure.Interfaces;
using API.MarginSKU.Presentation.Base;
using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace API.MarginSKU.Presentation.Controllers
{
    [ApiController, Route("api/[controller]")]
    public class ProjectsController : BaseApiController
    {
        private readonly IProjectService _projectService;

        public ProjectsController(IProjectService projectService)
        {
            _projectService = projectService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllAsync([FromQuery] string format = "json")
        {
            var projects = await _projectService.GetAllAsync();

            return FormatResponse(projects, format, '|', "projects");
        }
    }
}
