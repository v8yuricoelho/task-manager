# Task Manager

## Description

The **Task Manager** is the main service of a task management system that communicates with authentication, notification, and web scraping microservices. It allows users to create, view, update, and delete tasks, with all routes protected by JWT authentication.

## Features

- Full task CRUD operations.
- Tasks have statuses: Pending, In Progress, Completed, Failed.
- Integration with microservices for authentication, notifications, and web scraping.
- Automatic notifications for task updates.

## Technologies Used

- Ruby on Rails
- PostgreSQL
- JWT for authentication
- Shoryuken with AWS SQS for message processing
- Sidekiq with Redis for background processing

## Requirements

- **Ruby** 3.1.0 or higher
- **Rails** 7.0.0 or higher
- **PostgreSQL** 12 or higher
- **Redis** for Sidekiq
- **AWS SQS** configured for Shoryuken

## Environment Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/v8yuricoelho/task-manager.git
   cd task-manager
   ```

2. Install the dependencies:

   ```bash
   bundle install
   ```

3. Setup the database:

   ```bash
   rails db:create
   rails db:migrate
   ```

4. Set environment variables:

   Create a `.env` file in the project root with the following variables:

   ```bash
   AUTH_SERVICE_URL=http://localhost:3001
   SCRAPE_SERVICE_URL=http://localhost:3002
   NOTIFICATION_SERVICE_URL=http://localhost:3003
   AWS_ACCESS_KEY_ID=<your_aws_key>
   AWS_SECRET_ACCESS_KEY=<your_aws_secret>
   AWS_REGION=<your_aws_region>
   SQS_TASKS_QUEUE_URL=<your_aws_queue_url>
   ```

5. Start the server and workers:

   Start Rails:

   ```bash
   rails server
   ```

   Start Shoryuken to process AWS queues:

   ```bash
   bundle exec shoryuken -R -C config/shoryuken.yml -r ./app/workers -q <your_aws_queue_name>
   ```

   Start Sidekiq for background processing:

   ```bash
   bundle exec sidekiq
   ```

## Testing

To run tests, use the command:

```bash
rspec
```

## Related Microservices

- [Auth Service](https://github.com/v8yuricoelho/auth-service)
- [Scrape Service](https://github.com/v8yuricoelho/scrape-service)
- [Notification Service](https://github.com/v8yuricoelho/notification-service)


