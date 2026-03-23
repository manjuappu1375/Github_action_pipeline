// tests/app.test.js
const request = require('supertest');
const app = require('../app');

describe('Health Endpoint', () => {
  it('should return healthy status', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('healthy');
  });
});

describe('Greet Endpoint', () => {
  it('should greet by name', async () => {
    const res = await request(app).get('/api/greet?name=DevOps');
    expect(res.body.message).toBe('Hello, DevOps!');
  });
});