using API.MarginSKU.Application.Interfaces;
using API.MarginSKU.Domain.Entities;
using API.MarginSKU.Infrastructure.Interfaces;


namespace API.MarginSKU.Application.Services
{
    public class ProjectService : IProjectService
    {
        private readonly IProjectRepository _projectRepository;

        public ProjectService(IProjectRepository projectRepository)
        {
            _projectRepository = projectRepository;
        }

        public async Task<IEnumerable<Project>> GetAllAsync()
        {
            return await _projectRepository.GetAllAsync();
        }

    }
}
