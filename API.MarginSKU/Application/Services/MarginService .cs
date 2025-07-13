using API.MarginSKU.Application.Interfaces;
using API.MarginSKU.Domain.Entities;
using API.MarginSKU.Infrastructure.Interfaces;


namespace API.MarginSKU.Application.Services
{
    public class MarginService : IMarginService
    {
        private readonly IMarginRepository _marginRepository;

        public MarginService(IMarginRepository marginRepository)
        {
            _marginRepository = marginRepository;
        }

        public Task<IEnumerable<Margin>> GetAllAsync(DateTime fromDate, DateTime toDate)
        {
            return _marginRepository.GetAllAsync(fromDate, toDate);
        }

    }
}
