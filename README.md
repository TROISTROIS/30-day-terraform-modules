# Terraform Infrastructure Modules

This repository serves as the centralized directory for all Terraform modules used throughout the infrastructure and the 30-day challenge projects. By keeping all reusable modules in one location, we ensure consistency, version control, and easier maintainability across multiple environments.

## Directory Structure

The modules are organized by service and infrastructure domain.

```text
modules/
├── backend/             - S3 and DynamoDB resources for Terraform remote state management
├── landing-zone/
│   └── iam-user/        - IAM user creation and dynamic policy attachment
├── services/
│   ├── webserver/       - Web server and related infrastructure resources
│   └── ...              - Additional services
```

## How to Use These Modules

To use any of the modules in your Terraform configuration, reference the local path to the module directory or use the remote Git source.

### Local Reference Example

```hcl
module "webserver" {
  source = "../modules/services/webserver"
  
  # Module specific variables
  instance_type = "t2.micro"
  environment   = "production"
}
```

### Remote Git Reference Example

For version-controlled usage across different repositories, you can reference the modules via Git tags or branches:

```hcl
module "webserver" {
  source = "git::https://github.com/YourOrg/terraform-modules.git//services/webserver?ref=v1.0.0"
  
  # Module specific variables
  instance_type = "t2.micro"
  environment   = "production"
}
```

## Best Practices

*   **Immutability:** Treat modules as immutable components. Avoid making manual changes to deployed resources outside of Terraform.
*   **Versioning:** Always pin module versions in production environments to prevent unintended updates from breaking your infrastructure.
*   **Documentation:** Ensure that each module within the subdirectories has its own `README.md` detailing input variables, outputs, and usage examples.
*   **Encapsulation:** Keep modules focused on a single responsibility or a closely related group of resources.

## Development

When creating a new module, ensure it adheres to the standard Terraform module structure:

*   `main.tf`: Core resource definitions.
*   `variables.tf`: Input variable definitions with descriptions and types.
*   `outputs.tf`: Output values from the module.
*   `README.md`: Specific documentation for the module.
