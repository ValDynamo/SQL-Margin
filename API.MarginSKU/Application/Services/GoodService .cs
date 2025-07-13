using API.MarginSKU.Application.Interfaces;
using API.MarginSKU.Domain.Entities;
using API.MarginSKU.Infrastructure.Interfaces;


namespace API.MarginSKU.Application.Services
{
    public class GoodService : IGoodService
    {
        private readonly IGoodRepository _goodRepository;

        public GoodService(IGoodRepository goodRepository)
        {
            _goodRepository = goodRepository;
        }

        public async Task<IEnumerable<Good>> GetAllAsync()
        {
            return await _goodRepository.GetAllAsync();
        }

    }
}
